-module(mybank_atm).
-export([start_link/0,stop/0,init/0,deposit/2,balance/1,withdraw/2]).
-export([main_loop/1,current_balance/2]).

-record(state, {accounts}).

% ========== API =============

% Start the bank service
start_link() -> 
    io:format("==> Opening bank <==~n"),
    Pid = spawn_link(?MODULE,init,[]),
    register(?MODULE,Pid),
    {ok,Pid}.

% Stop the bank servcie
stop() ->
    ?MODULE ! terminate.

% Initialise and start the main function
init() ->
    Accounts = dict:new(),
    State = #state{accounts = Accounts},
    main_loop(State).

% Depositr an amount into the bank
deposit(AccountId,Amount) ->
    ?MODULE ! {deposit,self(),AccountId,Amount},
    receive
        {deposit_ok,Amount,CurrentBalance} -> 
            io:format("Status [deposit: ~p / balance: ~p]~n",[Amount,CurrentBalance]),
            ok
    after 5000 -> 
        {error,timeout}
    end.

balance(AccountId) ->
    ?MODULE ! {balance,self(),AccountId},
    receive
        {balance_ok,Balance} ->
            io:format("Balance [current: ~p]~n",[Balance]),
            ok
    after 5000 ->
        {error,timeout}
    end.

withdraw(AccountId,Amount) ->
    ?MODULE ! {withdraw,self(),AccountId,Amount},
    receive
        {withdraw_ok,Amount,Balance} ->
            io:format("Withdrawn [amount: ~p / balance ~p]~n",[Amount,Balance]),
            ok;
        {withdraw_error,Amount,Balance,Amount} ->
            io:format("Not enough funds [amount: ~p / balance ~p]~n",[Amount,Balance]),
            {error,Amount,Balance}
    after 5000 ->
        {error,timeout}
    end.

%  ============= Internal ============

% Helper to get ballance
current_balance(AccountId,Accounts) ->
    case dict:find(AccountId,Accounts) of
        error -> 0;
        {ok,Amount} -> Amount
    end.

% Main process for the bank
main_loop(#state{accounts = Accounts} = State) ->
    receive 
        {deposit,CallerPid,AccountId,Amount} ->
            CurrentBalance = current_balance(AccountId,Accounts),
            Accounts1 = dict:store(AccountId,CurrentBalance + Amount,Accounts),
            CallerPid ! {deposit_ok,Amount,CurrentBalance + Amount},
            main_loop(#state{accounts = Accounts1});
        {balance,CallerPid,AccountId} ->
            CallerPid ! {balance_ok,current_balance(AccountId,Accounts)},
            main_loop(State);
        {withdraw,CallerPid,AccountId,Amount} ->
            case current_balance(AccountId,Accounts) of 
                CurrentBalance when Amount =< CurrentBalance ->    
                    Accounts1 = dict:store(AccountId,CurrentBalance - Amount,Accounts),
                    CallerPid ! {withdraw_ok,Amount,CurrentBalance - Amount},
                    main_loop(#state{accounts = Accounts1});
                CurrentBalance when Amount > CurrentBalance ->
                    CallerPid ! {withdraw_error,Amount,CurrentBalance,Amount},
                    main_loop(State)
            end;
        terminate ->
            io:format("==> Closting bank <==~n")
    end.