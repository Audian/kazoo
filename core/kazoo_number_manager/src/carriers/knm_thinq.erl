%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2019, Audian.
%%% @doc A Number Manager module for carrier: thinq.com
%%% @author Pramod Venugopal
%%% @end
%%%-----------------------------------------------------------------------------

-module(knm_thinq).
-behaviour(knm_gen_carrier).

-export([info/0]).
-export([is_local/0]).
-export([find_numbers/3]).
-export([acquire_number/1]).
-export([disconnect_number/1]).
-export([should_lookup_cnam/0]).
-export([check_numbers/1]).
-export([is_number_billable/1]).

-include("knm.hrl").

-define(KNM_THINQ_CONFIG_CAT, <<(?KNM_CONFIG_CAT)/binary, ".thinq">>).
-define(KNM_THINQ_BASE_URL, kapps_config:get_string(?KNM_THINQ_CONFIG_CAT, <<"api_url">>, "")).
-define(KNM_THINQ_API_USER, kapps_config:get_string(?KNM_THINQ_CONFIG_CAT, <<"api_user">>, "")).
-define(KNM_THINQ_API_PASS, kapps_config:get_string(?KNM_THINQ_CONFIG_CAT, <<"api_pass">>, "")).
-define(KNM_THINQ_ACCOUNT_ID, kapps_config:get_string(?KNM_THINQ_CONFIG_CAT, <<"account_id">>, "").


%%------------------------------------------------------------------------------
%% @doc Is this carrier handling numbers local to the system
%% @end
%%------------------------------------------------------------------------------
-spec is_local() -> boolean().
is_local() -> 'false'.

%%------------------------------------------------------------------------------
%% @doc
%% @end
%%------------------------------------------------------------------------------
-spec info() -> map().
info() ->
  #{?CARRIER_INFO_MAX_PREFIX => 3}.

%%------------------------------------------------------------------------------
%% @doc Is this number billable
%% @end
%%------------------------------------------------------------------------------
-spec is_number_billable(knm_phone_number:knm_phone_number()) -> boolean().
is_number_billable(_Number) -> 'true'.

%%------------------------------------------------------------------------------
%% @doc Check to see if use_stepswitch_cnam is defined in the couchdoc. If it is
%% set to true, then incoming calls will use stepswitch for cnam
%% @end
%%------------------------------------------------------------------------------
-spec should_lookup_cnam() -> boolean().
should_lookup_cnam() -> 'true'.

%%------------------------------------------------------------------------------
%% @doc Check with carrier if these numbers are registered with it.
%% @end
%%------------------------------------------------------------------------------
-spec check_numbers(kz_term:ne_binaries()) -> {ok, kz_json:object()} |
                                              {error, any()}.
check_numbers(_Numbers) -> {error, not_implemented}.

%%------------------------------------------------------------------------------
%% @doc Query the system for a quantity of available numbers in a rate center
%% @end
%%------------------------------------------------------------------------------
-spec find_numbers(kz_term:ne_binary(), pos_integer(), knm_search:options()) ->
                          {'ok', knm_number:knm_numbers()} | {error, any()}.
find_numbers(_Prefix, _Quantity, _Options) -> {error, not_implemented}.

%%------------------------------------------------------------------------------
%% @doc Acquire a given number from the carrier.
%% @end
%%------------------------------------------------------------------------------
-spec acquire_number(knm_number:knm_number()) -> knm_number:knm_number() | 
                                                 {error, any()}.
acquire_number(_Number) -> {error, not_implemented}.

%%------------------------------------------------------------------------------
%% @doc Disconnect a given number from the carrier.
%% @end
%%------------------------------------------------------------------------------
-spec disconnect_number(knm_number:knm_number()) -> knm_number:knm_number() | 
                                                 {error, any()}.
disconnect_number(_Number) -> {error, not_implemented}.

%%% End of Module
