-module(mybank_sup).
-export([start/0,stop/0,init/0]).


start() ->
    Pid = spawn(?MODULE,init,[]),
    register(?MODULE,Pid).


init() ->
    process_flag(trap_exit,true),
    {ok, SupervisedPid} = mybank:start_link(),
    main_loop(SupervisedPid).

stop() ->
    ?MODULE ! terminate.

main_loop(SupervisedPid) ->
    receive
        {'EXIT',SupervisedPid,_} -> 
            error_logger:error_msg("mybank module crashed"),
            {ok,SupervisedPid1} = mybank:start_link(),
            main_loop(SupervisedPid1);
        terminate ->
            mybank:stop()
    end.