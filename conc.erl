-module(conc).
-export([conc/1]).

conc(File) ->
	{ok, S} = file:open(File, read),
	read([], 1, S).

read(Result, Line, S) ->
	R = io:get_line(S, ''),
	if eof =:= R ->
		Result;
	true ->
		R1 = string:tokens(R, "<>\|/+-=~^!@#$%&*()[]{}?:,. ;\n\t\v\"\'"),
		R2 = process_line(R1, Result, Line),
		R3 = read(R2, Line + 1, S),
		R3
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

