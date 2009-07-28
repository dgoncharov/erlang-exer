-module(ring).
-export([max/1]).


%% max(N)
%%   Create N processes then destroy them
%%   See how much time this takes

max(N) ->
    Max = erlang:system_info(process_limit),
    io:format("Maximum allowed processes:~p~n" ,[Max]),
    statistics(runtime),
    statistics(wall_clock),
    L = for(1, N, fun() -> spawn(fun() -> wait() end) end),
%    {_, Time1} = statistics(runtime),
%    {_, Time2} = statistics(wall_clock),
%    io:format("The list of processes: ~p~n", [L]),
    [H|T] = L,
    H ! {msg, self(), T},
%    lists:foreach(fun(Pid) -> Pid ! die end, L),
    receive
    msg -> io:format("the master process received a msg ~p~n", [self()])
    end,
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    io:format("runtime: ~p, wallclock: ~p, Process spawn time=~p (~p) microseconds~n", [Time1, Time2, U1, U2]).

wait() ->
    receive
    {msg, Pid, []} ->
        io:format("last process received a msg.~p~n", [self()]),
	Pid ! msg;
    {msg, Pid, [H|T]} ->
%	io:format("msg received by ~p~n", [self()]),
    	H ! {msg, Pid, T};
    die -> void
    end.

for(N, N, F) -> [F()];
for(I, N, F) -> [F()|for(I+1, N, F)].

