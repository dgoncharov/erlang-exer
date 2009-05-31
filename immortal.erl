-module(immortal).
-export([start/1]).

start(F) ->
	F2 = fun() -> worker(F) end,
	spawn(fun() -> endless(F2) end).

worker(Fun) ->
	receive
	quit -> io:format("quitting~n");
	X ->
		io:format("worker received ~p~n", [X]),
		Fun(X),
		worker(Fun)
	end.

endless(Fun) ->
	process_flag(trap_exit, true),
	Pid = spawn_link(Fun),
	endless(Pid, Fun).

endless(Pid, Fun) ->
	receive
	{'EXIT', Pid, normal} ->
		io:format("process ~p exited with normal~n", [Pid]);
	{'EXIT', Pid, Why} ->
		io:format("process ~p exited with ~p~n", [Pid, Why]),
		Pid1 = spawn_link(Fun),
		endless(Pid1, Fun);
	X -> io:format("endless received ~p~n", [X]),
		Pid ! X,
		endless(Pid, Fun)
	end.

