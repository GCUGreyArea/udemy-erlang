-module(mybank_sup).
-export([start_link/0,init/1]).

start_link() ->
    supervisor:start_link({local,?MODULE},?MODULE,[]).

init([]) ->
    Children = [
        {
            % ID
            mybank_atm,
            % mdule, start, args
            {mybank_atm,start_link,[]},
            % restart_type
            permanent,
            % Timeout 
            10000,
            % Type
            worker,
            % module
            [mybank_atm]
        }
    ],
    {ok,{{one_for_one,10,10},Children}}.

