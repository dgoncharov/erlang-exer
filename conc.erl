-module(conc).
-export([main/1]).
-export([conc/1]).

main([A]) ->
	R = conc(A),
	print(R).

conc(File) ->
	{ok, FD} = file:open(File, read),
	process_line(io:get_line(FD, ''), [], 1, FD).

process_line(eof, Result, _, _) ->
	Result;

process_line(String, Result, Linenum, FD) ->
	R1 = string:tokens(String, "<>\|/+-=~^!@#$%&*()[]{}?:,. ;\n\t\v\"\'"),
	R2 = process_words(R1, Result, Linenum),
	R3 = process_line(io:get_line(FD, ''), R2, Linenum + 1, FD),
	R3.

process_words([H|_T]=L, Result, Linenum) ->
	R = lists:keyfind({H, Linenum}, 1, Result),
	process_word(R, L, Result, Linenum);

process_words([], Result, _) ->
	Result.

process_word(false, [H|T], Result, Linenum) ->
	R = lists:append(Result, [{{H, Linenum}, 1}]),
	process_words(T, R, Linenum);

process_word(Tuple, [H|T], Result, Linenum) ->
        R = [{{W, Linenum2}, N} || {{W, Linenum2}, N} <- Result, (W =/= H) or (Linenum2 =/= Linenum)],
	{{W, _Linenum}, N} = Tuple, %TODO: read the line and assert it is equal to Linenum
	R1 = lists:append(R, [{{W, Linenum}, N + 1}]),
	process_words(T, R1, Linenum).

print([{{W, _Linenum}, _N}|_T]=Result) ->
	io:format("~p~n", [W]),
	Stats = [{Linenum2, N2} || {{W2, Linenum2}, N2} <- Result, W2 =:= W],
	io:format("    ~p~n", [Stats]),
	Other = [{{W2, Linenum2}, N2} || {{W2, Linenum2}, N2} <- Result, (W2 =/= W)],
	print(Other);

print([]) ->
	io:format("~n").

