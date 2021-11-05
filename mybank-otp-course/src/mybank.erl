-module(mybank).
-export([deposit/2,balance/1,withdraw/2]).
-export([start/0,stop/0]).

start() ->
    application:start(mybank).

stop() -> 
    application:stop(mybank).

deposit(AccountId,Amount) ->
    mybank_atm:deposit(AccountId,Amount).

balance(AccountId) -> 
    mybank_atm:balance(AccountId).

withdraw(AccountId,Amount) ->
    mybank_atm:withdraw(AccountId,Amount).
