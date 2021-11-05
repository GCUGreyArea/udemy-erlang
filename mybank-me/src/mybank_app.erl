%%%-------------------------------------------------------------------
%% @doc mybank public API
%% @end
%%%-------------------------------------------------------------------

-module(mybank_app).
-behaviour(application).

-export([start/2, stop/1, init/1]).
-record(state, {accounts}).

start(_StartType, _StartArgs) ->
    io:format("Starting up ~n"),
    mybank_sup:start_link().

stop(_State) ->
    ok.

init([]) ->
    io:format("Initialising~n"),
    Accounts = dict:new(),
    State = #state{accounts = Accounts},
    {ok,State}.
%% internal functions
