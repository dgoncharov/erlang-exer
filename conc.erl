-module(conc).
-export([main/1]).
-export([conc/1]).

main([A]) ->
	R = conc(A),
	io:format("~p~n", [R]),
	init:stop().

conc(File) ->
	{ok, S} = file:open(File, read),
	process_line(io:get_line(S, ''), [], 1, S).


process_line(eof, Result, _, _) ->
	Result;

process_line(String, Result, Line, S) ->
		R1 = string:tokens(String, "<>\|/+-=~^!@#$%&*()[]{}?:,. ;\n\t\v\"\'"),
		R2 = process_words(R1, Result, Line),
		R3 = process_line(io:get_line(S, ''), R2, Line + 1, S),
		R3.

process_words([H|T], Result, Line) ->
	R = lists:keyfind({H, Line}, 1, Result),
	if R =:= false ->
		R1 = lists:append(Result, [{{H, Line}, 1}]),
		process_words(T, R1, Line);
	true ->
                R2 = [{{W, Line2}, N2} || {{W, Line2}, N2} <- Result, (W =/= H) or (Line2 =/= Line)],
		{{W, _}, N2} = R, %TODO: read the line and assert it is equal to Line
		R3 = lists:append(R2, [{{W, Line}, N2 + 1}]),
		process_words(T, R3, Line)
	end;

process_words([], Result, _) ->
	Result.

