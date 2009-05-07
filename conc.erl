-module(conc).
-export([conc/1]).

conc(File) ->
	{ok, S} = file:open(File, read),
	read([], 1, S).

read(L, N, S) ->
	R = io:get_line(S, ''),
	if eof =:= R ->
		L;
	true ->
		R1 = string:tokens(R, ",. ;\n"),
		R2 = process_line(R1, L, N),
		read(R2, N + 1, S)
	end.


process_line([H|T], Result, Line) ->
	R = lists:keyfind({H, Line}, 1, Result),
	if R =:= false ->
		R1 = lists:append(Result, [{{H, Line}, 1}]),
		process_line(T, R1, Line);
	true ->
                R2 = [{{W, Line2}, N2} || {{W, Line2}, N2} <- Result, (W =/= H) or (Line2 =/= Line)],
		{{W, _}, N2} = R, %TODO: read the line and assert it is equal to Line
		R3 = lists:append(R2, [{{W, Line}, N2 + 1}]),
		process_line(T, R3, Line)
	end;

process_line([], Result, _) ->
	Result.

