%%%-------------------------------------------------------------------
%%% @copyright (C) 2012, VoIP INC
%%% @doc
%%%
%%% @end
%%% @contributors
%%%   James Aimonetti
%%%-------------------------------------------------------------------
-module(wapi_acdc_queue).

-export([member_connect_req/1, member_connect_req_v/1
         ,member_connect_resp/1, member_connect_resp_v/1
         ,member_connect_win/1, member_connect_win_v/1
         ,member_connect_monitor/1, member_connect_monitor_v/1
         ,member_connect_ignore/1, member_connect_ignore_v/1
         ,member_connect_retry/1, member_connect_retry_v/1
         ,member_hungup/1, member_hungup_v/1
        ]).

-export([bind_q/2
         ,unbind_q/2
        ]).

-export([publish_member_connect_req/1, publish_member_connect_req/2
         ,publish_member_connect_resp/2, publish_member_connect_resp/3
         ,publish_member_connect_win/2, publish_member_connect_win/3
         ,publish_member_connect_monitor/2, publish_member_connect_monitor/3
         ,publish_member_connect_ignore/2, publish_member_connect_ignore/3
         ,publish_member_connect_retry/2, publish_member_connect_retry/3
         ,publish_member_hungup/2, publish_member_hungup/3
        ]).

-include("acdc.hrl").

%%------------------------------------------------------------------------------
%% Member Connect Request
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_REQ_KEY, "member.connect_req."). % append queue ID

-define(MEMBER_CONNECT_REQ_HEADERS, [<<"Queue-ID">>]).
-define(OPTIONAL_MEMBER_CONNECT_REQ_HEADERS, []).
-define(MEMBER_CONNECT_REQ_VALUES, [{<<"Event-Category">>, <<"member">>}
                                    ,{<<"Event-Name">>, <<"connect_req">>}
                                   ]).
-define(MEMBER_CONNECT_REQ_TYPES, []).

-spec member_connect_req/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_req(Props) when is_list(Props) ->
    case member_connect_req_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_REQ_HEADERS, ?OPTIONAL_MEMBER_CONNECT_REQ_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_req"}
    end;
member_connect_req(JObj) ->
    member_connect_req(wh_json:to_proplist(JObj)).

-spec member_connect_req_v/1 :: (api_terms()) -> boolean().
member_connect_req_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_REQ_HEADERS, ?MEMBER_CONNECT_REQ_VALUES, ?MEMBER_CONNECT_REQ_TYPES);
member_connect_req_v(JObj) ->
    member_connect_req_v(wh_json:to_proplist(JObj)).

-spec member_connect_req_routing_key/1 :: (ne_binary() | 
                                           wh_json:json_object() |
                                           wh_proplist()
                                          ) -> ne_binary().
member_connect_req_routing_key(?NE_BINARY = Id) ->
    <<?MEMBER_CONNECT_REQ_KEY, Id/binary>>;
member_connect_req_routing_key(Props) when is_list(Props) ->
    Id = props:get_value(<<"Queue-ID">>, Props, <<"*">>),
    <<?MEMBER_CONNECT_REQ_KEY, Id/binary>>;
member_connect_req_routing_key(JObj) ->
    Id = wh_json:get_value(<<"Queue-ID">>, JObj, <<"*">>),
    <<?MEMBER_CONNECT_REQ_KEY, Id/binary>>.

%%------------------------------------------------------------------------------
%% Member Connect Response
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_RESP_HEADERS, [<<"Agent-ID">>]).
-define(OPTIONAL_MEMBER_CONNECT_RESP_HEADERS, [<<"Idle-Time">>, <<"Process-ID">>]).
-define(MEMBER_CONNECT_RESP_VALUES, [{<<"Event-Category">>, <<"member">>}
                                    ,{<<"Event-Name">>, <<"connect_resp">>}
                                   ]).
-define(MEMBER_CONNECT_RESP_TYPES, []).

-spec member_connect_resp/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_resp(Props) when is_list(Props) ->
    case member_connect_resp_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_RESP_HEADERS, ?OPTIONAL_MEMBER_CONNECT_RESP_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_resp"}
    end;
member_connect_resp(JObj) ->
    member_connect_resp(wh_json:to_proplist(JObj)).

-spec member_connect_resp_v/1 :: (api_terms()) -> boolean().
member_connect_resp_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_RESP_HEADERS, ?MEMBER_CONNECT_RESP_VALUES, ?MEMBER_CONNECT_RESP_TYPES);
member_connect_resp_v(JObj) ->
    member_connect_resp_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Member Connect Win
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_WIN_HEADERS, [<<"Queue-ID">>, <<"Call">>]).
-define(OPTIONAL_MEMBER_CONNECT_WIN_HEADERS, []).
-define(MEMBER_CONNECT_WIN_VALUES, [{<<"Event-Category">>, <<"member">>}
                                     ,{<<"Event-Name">>, <<"connect_win">>}
                                    ]).
-define(MEMBER_CONNECT_WIN_TYPES, []).

-spec member_connect_win/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_win(Props) when is_list(Props) ->
    case member_connect_win_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_WIN_HEADERS, ?OPTIONAL_MEMBER_CONNECT_WIN_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_win"}
    end;
member_connect_win(JObj) ->
    member_connect_win(wh_json:to_proplist(JObj)).

-spec member_connect_win_v/1 :: (api_terms()) -> boolean().
member_connect_win_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_WIN_HEADERS, ?MEMBER_CONNECT_WIN_VALUES, ?MEMBER_CONNECT_WIN_TYPES);
member_connect_win_v(JObj) ->
    member_connect_win_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Member Connect Monitor
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_MONITOR_HEADERS, [<<"Call-ID">>]).
-define(OPTIONAL_MEMBER_CONNECT_MONITOR_HEADERS, []).
-define(MEMBER_CONNECT_MONITOR_VALUES, [{<<"Event-Category">>, <<"member">>}
                                        ,{<<"Event-Name">>, <<"connect_monitor">>}
                                       ]).
-define(MEMBER_CONNECT_MONITOR_TYPES, []).

-spec member_connect_monitor/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_monitor(Props) when is_list(Props) ->
    case member_connect_monitor_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_MONITOR_HEADERS, ?OPTIONAL_MEMBER_CONNECT_MONITOR_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_monitor"}
    end;
member_connect_monitor(JObj) ->
    member_connect_monitor(wh_json:to_proplist(JObj)).

-spec member_connect_monitor_v/1 :: (api_terms()) -> boolean().
member_connect_monitor_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_MONITOR_HEADERS, ?MEMBER_CONNECT_MONITOR_VALUES, ?MEMBER_CONNECT_MONITOR_TYPES);
member_connect_monitor_v(JObj) ->
    member_connect_monitor_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Member Connect Ignore
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_IGNORE_HEADERS, [<<"Call-ID">>]).
-define(OPTIONAL_MEMBER_CONNECT_IGNORE_HEADERS, []).
-define(MEMBER_CONNECT_IGNORE_VALUES, [{<<"Event-Category">>, <<"member">>}
                                       ,{<<"Event-Name">>, <<"connect_ignore">>}
                                      ]).
-define(MEMBER_CONNECT_IGNORE_TYPES, []).

-spec member_connect_ignore/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_ignore(Props) when is_list(Props) ->
    case member_connect_ignore_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_IGNORE_HEADERS, ?OPTIONAL_MEMBER_CONNECT_IGNORE_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_ignore"}
    end;
member_connect_ignore(JObj) ->
    member_connect_ignore(wh_json:to_proplist(JObj)).

-spec member_connect_ignore_v/1 :: (api_terms()) -> boolean().
member_connect_ignore_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_IGNORE_HEADERS, ?MEMBER_CONNECT_IGNORE_VALUES, ?MEMBER_CONNECT_IGNORE_TYPES);
member_connect_ignore_v(JObj) ->
    member_connect_ignore_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Member Connect Retry
%%------------------------------------------------------------------------------
-define(MEMBER_CONNECT_RETRY_HEADERS, [<<"Call-ID">>]).
-define(OPTIONAL_MEMBER_CONNECT_RETRY_HEADERS, []).
-define(MEMBER_CONNECT_RETRY_VALUES, [{<<"Event-Category">>, <<"member">>}
                                      ,{<<"Event-Name">>, <<"connect_retry">>}
                                     ]).
-define(MEMBER_CONNECT_RETRY_TYPES, []).

-spec member_connect_retry/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_connect_retry(Props) when is_list(Props) ->
    case member_connect_retry_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_CONNECT_RETRY_HEADERS, ?OPTIONAL_MEMBER_CONNECT_RETRY_HEADERS);
        false -> {error, "Proplist failed validation for member_connect_retry"}
    end;
member_connect_retry(JObj) ->
    member_connect_retry(wh_json:to_proplist(JObj)).

-spec member_connect_retry_v/1 :: (api_terms()) -> boolean().
member_connect_retry_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_CONNECT_RETRY_HEADERS, ?MEMBER_CONNECT_RETRY_VALUES, ?MEMBER_CONNECT_RETRY_TYPES);
member_connect_retry_v(JObj) ->
    member_connect_retry_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Member Hungup
%%------------------------------------------------------------------------------
-define(MEMBER_HUNGUP_HEADERS, [<<"Call-ID">>]).
-define(OPTIONAL_MEMBER_HUNGUP_HEADERS, []).
-define(MEMBER_HUNGUP_VALUES, [{<<"Event-Category">>, <<"member">>}
                               ,{<<"Event-Name">>, <<"hungup">>}
                              ]).
-define(MEMBER_HUNGUP_TYPES, []).

-spec member_hungup/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
member_hungup(Props) when is_list(Props) ->
    case member_hungup_v(Props) of
        true -> wh_api:build_message(Props, ?MEMBER_HUNGUP_HEADERS, ?OPTIONAL_MEMBER_HUNGUP_HEADERS);
        false -> {error, "Proplist failed validation for member_hungup"}
    end;
member_hungup(JObj) ->
    member_hungup(wh_json:to_proplist(JObj)).

-spec member_hungup_v/1 :: (api_terms()) -> boolean().
member_hungup_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?MEMBER_HUNGUP_HEADERS, ?MEMBER_HUNGUP_VALUES, ?MEMBER_HUNGUP_TYPES);
member_hungup_v(JObj) ->
    member_hungup_v(wh_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% Bind/Unbind the queue as appropriate
%%------------------------------------------------------------------------------

-spec bind_q/2 :: (ne_binary(), wh_proplist()) -> 'ok'.
bind_q(Q, Props) ->
    QID = props:get_value(queue_id, Props, <<"*">>),

    amqp_util:callmgr_exchange(),
    amqp_util:bind_q_to_callmgr(Q, member_connect_req_routing_key(QID)).

-spec unbind_q/2 :: (ne_binary(), wh_proplist()) -> 'ok'.
unbind_q(Q, Props) ->
    QID = props:get_value(queue_id, Props, <<"*">>),

    amqp_util:unbind_q_from_callmgr(Q, member_connect_req_routing_key(QID)).


%%------------------------------------------------------------------------------
%% Publishers for convenience
%%------------------------------------------------------------------------------

-spec publish_member_connect_req/1 :: (api_terms()) -> 'ok'.
-spec publish_member_connect_req/2 :: (api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_req(JObj) ->
    publish_member_connect_req(JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_req(API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_REQ_VALUES, fun member_connect_req/1),
    amqp_util:callmgr_publish(Payload, ContentType, member_connect_req_routing_key(API)).

-spec publish_member_connect_resp/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_connect_resp/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_resp(Q, JObj) ->
    publish_member_connect_resp(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_resp(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_RESP_VALUES, fun member_connect_resp/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).

-spec publish_member_connect_win/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_connect_win/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_win(Q, JObj) ->
    publish_member_connect_win(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_win(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_WIN_VALUES, fun member_connect_win/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).

-spec publish_member_connect_monitor/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_connect_monitor/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_monitor(Q, JObj) ->
    publish_member_connect_monitor(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_monitor(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_MONITOR_VALUES, fun member_connect_monitor/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).

-spec publish_member_connect_ignore/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_connect_ignore/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_ignore(Q, JObj) ->
    publish_member_connect_ignore(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_ignore(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_IGNORE_VALUES, fun member_connect_ignore/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).

-spec publish_member_connect_retry/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_connect_retry/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_connect_retry(Q, JObj) ->
    publish_member_connect_retry(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_connect_retry(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_CONNECT_RETRY_VALUES, fun member_connect_retry/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).

-spec publish_member_hungup/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_member_hungup/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_member_hungup(Q, JObj) ->
    publish_member_hungup(Q, JObj, ?DEFAULT_CONTENT_TYPE).
publish_member_hungup(Q, API, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(API, ?MEMBER_HUNGUP_VALUES, fun member_hungup/1),
    amqp_util:targeted_publish(Q, Payload, ContentType).
