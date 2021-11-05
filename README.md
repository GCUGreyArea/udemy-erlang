# Udemy Erlang course
This is the work product of the Udemy course [Modern Erlang for Beginners](https://www.udemy.com/course/modern-erlang-for-beginners/)
## Project directories 

### mybank-course 
This is the initial course material
```
cd mybank-course/src
erl
> c(mybank).
```
#### mybank-otp-course 
This is the output from the latter part of the course where OTP is covered, however this application does not boot on it's own, which might be a configuration detail. At any rate, the application seems to have been designed that way.
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