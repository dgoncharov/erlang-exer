-module(conc).
-export([main/1]).
-export([conc/1]).

main([A]) ->
	R = conc(A),
	%%TODO: print the dict somehow w/o converting to a list
	L = dict:to_list(R),
	R2 = lists:keysort(1, L),
	print(R2).

conc(File) ->
	{ok, FD} = file:open(File, read),
	Result = dict:new(),
	process_line(io:get_line(FD, ''), Result, 1, FD).

process_line(eof, Result, _, _) ->
	Result;

process_line(String, Result, Linenum, FD) ->
	R1 = string:tokens(String, "<>\|/+-=~^!@#$%&*()[]{}?:,. ;\n\t\v\"\'"),
	R2 = process_words(R1, Result, Linenum),
	process_line(io:get_line(FD, ''), R2, Linenum + 1, FD).

%% {Word, Linenum} -> NOccurences
process_words([W|T], Result, Linenum) ->
	case dict:find({W, Linenum}, Result) of
	{ok, N} ->
		R = dict:store({W, Linenum}, N+1, Result);
	error ->
		R = dict:store({W, Linenum}, 1, Result)
	end,
	process_words(T, R, Linenum);

process_words([], Result, _) ->
	Result.

print([{{W, _Linenum}, _N}|_T]=Result) ->
	io:format("~s~n", [W]),
	Stats = [{Linenum2, N2} || {{W2, Linenum2}, N2} <- Result, W2 =:= W],
	lists:foreach(fun({Linenum, N}) -> io:format("    ~B: ~B~n", [Linenum, N]) end, Stats),
	io:format("~n"),
	Other = [{{W2, Linenum2}, N2} || {{W2, Linenum2}, N2} <- Result, (W2 =/= W)],
	print(Other);

print([]) ->
	io:format("~n").


