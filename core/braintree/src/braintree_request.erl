%%%-------------------------------------------------------------------
%%% @copyright (C) 2011-2015, 2600Hz INC
%%% @doc
%%%
%%% @end
%%% @contributors
%%%   Karl Anderson
%%%-------------------------------------------------------------------
-module(braintree_request).

-export([get/1]).
-export([post/2]).
-export([put/2]).
-export([delete/1]).

-include_lib("braintree/include/braintree.hrl").

-type http_verb() :: 'put' | 'post' | 'get' | 'delete'.

-define(BT_DEFAULT_ENVIRONMENT, whapps_config:get_string(<<"braintree">>, <<"default_environment">>, <<>>)).
-define(BT_DEFAULT_MERCHANT_ID, whapps_config:get_string(<<"braintree">>, <<"default_merchant_id">>, <<>>)).
-define(BT_DEFAULT_PUBLIC_KEY, whapps_config:get_string(<<"braintree">>, <<"default_public_key">>, <<>>)).
-define(BT_DEFAULT_PRIVATE_KEY, whapps_config:get_string(<<"braintree">>, <<"default_private_key">>, <<>>)).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Preform a get request to braintree's system
%% @end
%%--------------------------------------------------------------------
-spec get(nonempty_string()) -> bt_xml().
get(Path) ->
    do_request('get', Path, <<>>).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Preform a post request to braintree's system
%% @end
%%--------------------------------------------------------------------
-spec post(nonempty_string(), binary()) -> bt_xml().
post(Path, Request) ->
    do_request('post', Path, Request).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Preform a put request to braintree's system
%% @end
%%--------------------------------------------------------------------
-spec put(nonempty_string(), binary()) -> bt_xml().
put(Path, Request) ->
    do_request('put', Path, Request).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Preform a delete request to braintree's system
%% @end
%%--------------------------------------------------------------------
-spec delete(nonempty_string()) -> bt_xml().
delete(Path) ->
    do_request('delete', Path, <<>>).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Preform a request to the braintree service
%% @end
%%--------------------------------------------------------------------
-spec do_request(http_verb(), nonempty_string(), binary()) -> bt_xml().
do_request(Method, Path, Body) ->
    case braintree_server_url(?BT_DEFAULT_ENVIRONMENT) of
        'undefined' ->
            lager:error("braintree configuration error: default_environment not set"),
            _WillCrash = build_url(Path);  %% We should not continue anyway
        _Ok ->
            request(Method, Path, Body)
    end.

-spec request(http_verb(), nonempty_string(), binary()) -> bt_xml().
request(Method, Path, Body) ->
    StartTime = os:timestamp(),

    lager:debug("making ~s request to braintree ~s", [Method, Path]),
    Url = build_url(Path),

    Headers = request_headers(),
    HTTPOptions = http_options(),
    verbose_debug("Request:~n~s ~s~n~s~n", [Method, Url, Body]),

    case kz_http:req(Method, Url, Headers, Body, HTTPOptions) of
        {'ok', "401", _, _Response} ->
            verbose_debug("Response:~n401~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 401 Unauthenticated", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_authentication();
        {'ok', "403", _, _Response} ->
            verbose_debug("Response:~n403~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 403 Unauthorized", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_authorization();
        {'ok', "404", _, _Response} ->
            verbose_debug("Response:~n404~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 404 Not Found", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_not_found(<<>>);
        {'ok', "426", _, _Response} ->
            verbose_debug("Response:~n426~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 426 Upgrade Required", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_upgrade_required();
        {'ok', "500", _, _Response} ->
            verbose_debug("Response:~n500~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 500 Server Error", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_server_error();
        {'ok', "503", _, _Response} ->
            verbose_debug("Response:~n503~n~s~n", [_Response]),
            lager:debug("braintree error response(~pms): 503 Maintenance", [wh_util:elapsed_ms(StartTime)]),
            braintree_util:error_maintenance();
        {'ok', Code, _, "<?xml"++_=Response} ->
            verbose_debug("Response:~n~p~n~s~n", [Code, Response]),
            {Xml, _} = xmerl_scan:string(Response),
            lager:debug("braintree xml response(~pms)", [wh_util:elapsed_ms(StartTime)]),
            verify_response(Xml);
        {'ok', Code, _, "<search"++_=Response} ->
            verbose_debug("Response:~n~p~n~s~n", [Code, Response]),
            {Xml, _} = xmerl_scan:string(Response),
            lager:debug("braintree xml response(~pms)", [wh_util:elapsed_ms(StartTime)]),
            verify_response(Xml);
        {'ok', Code, _, _Response} ->
            verbose_debug("Response:~n~p~n~s~n", [Code, _Response]),
            lager:debug("braintree empty response(~pms): ~p", [wh_util:elapsed_ms(StartTime), Code]),
            ?BT_EMPTY_XML;
        {'error', _R} ->
            verbose_debug("Response:~nerror~n~p~n", [_R]),
            lager:debug("braintree request error(~pms): ~p", [wh_util:elapsed_ms(StartTime), _R]),
            braintree_util:error_io_fault()
    end.

-spec build_url(text()) -> text().
build_url(Path) ->
    lists:flatten(["https://"
                   ,braintree_server_url(?BT_DEFAULT_ENVIRONMENT)
                   ,"/merchants/", ?BT_DEFAULT_MERCHANT_ID
                   ,Path
                  ]).

-spec request_headers() -> [{string(), string()}].
request_headers() ->
    [{"Accept", "application/xml"}
     ,{"User-Agent", "Braintree Erlang Library 1"}
     ,{"X-ApiVersion", wh_util:to_list(?BT_API_VERSION)}
     ,{"Content-Type", "application/xml"}
    ].

-type ssl_option() :: {'ssl', wh_proplist()}.
-type basic_auth_option() :: {'basic_auth', {string(), string()}}.

-spec http_options() -> [ssl_option() | basic_auth_option()].
http_options() ->
    [{'ssl',[{'verify', 'verify_none'}]}
     ,{'basic_auth', {?BT_DEFAULT_PUBLIC_KEY
                      ,?BT_DEFAULT_PRIVATE_KEY
                     }
      }
    ].

%%--------------------------------------------------------------------
%% @private
%% @doc
%% If braintree verbose debuging is enabled write the log line to the file
%% @end
%%--------------------------------------------------------------------
-spec verbose_debug(string(), [any()]) -> 'ok'.
verbose_debug(Format, Args) ->
    case ?BT_DEBUG of
        'false' -> 'ok';
        'true' ->
            wh_util:write_file("/tmp/braintree.xml", io_lib:format(Format, Args), ['append'])
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Get the base URL for the braintree service
%% @end
%%--------------------------------------------------------------------
-spec braintree_server_url(string()) -> string() | 'undefined'.
braintree_server_url(Env) ->
    proplists:get_value(Env, ?BT_SERVER_URL).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Determine if the response was valid
%% @end
%%--------------------------------------------------------------------
-spec verify_response(bt_xml()) -> bt_xml().
verify_response(Xml) ->
    case xmerl_xpath:string("/api-error-response", Xml) of
        [] -> Xml;
        _ -> error_response(Xml)
    end.

-spec error_response(bt_xml()) -> no_return().
error_response(Xml) ->
    lager:debug("braintree api error response"),
    Errors = [#bt_error{code = wh_util:get_xml_value("/error/code/text()", Error)
                        ,message = wh_util:get_xml_value("/error/message/text()", Error)
                        ,attribute = wh_util:get_xml_value("/error/attribute/text()", Error)
                       }
              || Error <- xmerl_xpath:string("/api-error-response/errors//errors/error", Xml)
             ],
    Verif = #bt_verification{verification_status =
                                 wh_util:get_xml_value("/api-error-response/verification/status/text()", Xml)
                             ,processor_response_code =
                                 wh_util:get_xml_value("/api-error-response/verification/processor-response-code/text()", Xml)
                             ,processor_response_text =
                                 wh_util:get_xml_value("/api-error-response/verification/processor-response-text/text()", Xml)
                             ,cvv_response_code =
                                 wh_util:get_xml_value("/api-error-response/verification/cvv-response-code/text()", Xml)
                             ,avs_response_code =
                                 wh_util:get_xml_value("/api-error-response/verification/avs-error-response-code/text()", Xml)
                             ,postal_response_code =
                                 wh_util:get_xml_value("/api-error-response/verification/avs-postal-code-response-code/text()", Xml)
                             ,street_response_code =
                                 wh_util:get_xml_value("/api-error-response/verification/avs-street-address-response-code/text()", Xml)
                             ,gateway_rejection_reason =
                                 wh_util:get_xml_value("/api-error-response/verification/gateway-rejection-reason/text()", Xml)
                            },
    braintree_util:error_api(
      #bt_api_error{errors=Errors
                    ,verification=Verif
                    ,message=wh_util:get_xml_value("/api-error-response/message/text()", Xml)
                   }
     ).
