-module(conc).
-export([main/1]).
-export([conc/1]).

main([A]) ->
	R = conc(A),
	io:format("~p~n", [R]),
	init:stop().

conc(File) ->
	{ok, FD} = file:open(File, read),
	process_line(io:get_line(FD, ''), [], 1, FD).

process_line(eof, Result, _, _) ->
	Result;

process_line(String, Result, Line, FD) ->
	R1 = string:tokens(String, "<>\|/+-=~^!@#$%&*()[]{}?:,. ;\n\t\v\"\'"),
	R2 = process_words(R1, Result, Line),
	R3 = process_line(io:get_line(FD, ''), R2, Line + 1, FD),
	R3.

process_words([H|_T]=L, Result, Line) ->
	R = lists:keyfind({H, Line}, 1, Result),
	process_word(R, L, Result, Line);

process_words([], Result, _) ->
	Result.

process_word(false, [H|T], Result, Line) ->
	R = lists:append(Result, [{{H, Line}, 1}]),
	process_words(T, R, Line);

process_word(Tuple, [H|T], Result, Line) ->
        R = [{{W, Line2}, N} || {{W, Line2}, N} <- Result, (W =/= H) or (Line2 =/= Line)],
	{{W, _Line}, N} = Tuple, %TODO: read the line and assert it is equal to Line
	R1 = lists:append(R, [{{W, Line}, N + 1}]),
	process_words(T, R1, Line).

