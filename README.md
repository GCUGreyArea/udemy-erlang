# Udemy Erlang course
## Project directories 

### Initial course material. 
#### mybank-course 
```
cd mybank-course/src
erl
> c(mybank).
```
#### mybank-otp-course 
```
cd mybank-otp-course
erlc -o ebin src/*.erl
erl -pa ebin
mybank:start().
```
#### mybank-me
This is unfinished work that uses rebar3 to create an OTP app. The app boots, but I haven't figured out how to setup the state variable for gen_server. 
```
cd mybank-me
rebar3 shell