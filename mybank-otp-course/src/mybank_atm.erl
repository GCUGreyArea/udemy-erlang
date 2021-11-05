-module(mybank_atm).
-behavoiur(gen_server).

-export([start_link/0,stop/0,init/1,deposit/2,balance/1,withdraw/2]).
-export([handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([current_balance/2]).

-record(state, {accounts}).

% ========== API =============

% Start the bank service
start_link() -> 
    io:format("==> Opening bank <==~n"),
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).

% Stop the bank servcie
stop() ->
    gen_server:stop(?MODULE).

% Initialise
init([]) ->
    io:format("==> Making dictionary <==~n"),
    Accounts = dict:new(),
    State = #state{accounts = Accounts},
    {ok,State}.


% Depositr an amount into the bank
deposit(AccountId,Amount) ->
    gen_server:call(?MODULE,{deposit,AccountId,Amount}).

balance(AccountId) ->
    gen_server:call(?MODULE,{balance,AccountId}).

withdraw(AccountId,Amount) ->
    gen_server:call(?MODULE,{withdraw,AccountId,Amount}).

%  ============= Internal ============

% Main process for the bank
handle_call({deposit,AccountId,Amount},_From,#state{accounts = Accounts} = State) ->
    CurrentBalance = current_balance(AccountId,Accounts),
    Accounts1 = dict:store(AccountId,CurrentBalance + Amount,Accounts),
    {reply, CurrentBalance + Amount, State#state{accounts = Accounts1}}; 

handle_call({balance,AccountId},_From,#state{accounts = Accounts} = State) ->
    {reply,current_balance(AccountId,Accounts),State};

handle_call({withdraw,AccountId,Amount},_From,#state{accounts = Accounts} = State) ->
    case current_balance(AccountId,Accounts) of 
        CurrentBalance when Amount =< CurrentBalance ->    
            Accounts1 = dict:store(AccountId,CurrentBalance - Amount,Accounts),
            {reply,{ok,Amount,CurrentBalance - Amount},State#state{accounts = Accounts1}};
        CurrentBalance when Amount > CurrentBalance ->
            {reply,{withdraw_error,Amount,CurrentBalance},State}
    end;

handle_call(_Msg,_From,State) ->
    {reply,undefined,State}.

handle_cast(_Msg,State) ->
    {noreply,State}.

handle_info(_From,State) ->
    {noreply,State}.

terminate(_Reason,_State) ->
    io:format("Closing bank ~n").

code_change(_OldVsn,State,_Extra) ->
    {ok,State}.

% Helper to get ballance
current_balance(AccountId,Accounts) ->
    case dict:find(AccountId,Accounts) of
        error -> 0;
        {ok,Amount} -> Amount
    end.