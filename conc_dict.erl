-module(conc).
-export([main/1]).
-export([conc/1]).

main([A]) ->
	D = conc(A),
	Keys = dict:fetch_keys(D),
	Keys1 = lists:sort(Keys),
	print(Keys1, D).

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

process_words([W|T], Result, Linenum) ->
	case dict:find(W, Result) of
	{ok, D} ->
		case dict:find(Linenum, D) of
		{ok, N} ->
			D1 = dict:store(Linenum, N+1, D);
		error ->
			D1 = dict:store(Linenum, 1, D)
		end,
		D2 = dict:store(W, D1, Result);
	error ->
		D = dict:new(),
		D1 = dict:store(Linenum, 1, D),
		D2 = dict:store(W, D1, Result)
	end,
	process_words(T, D2, Linenum);

process_words([], Result, _) ->
	Result.

print([K|T], D) ->
	io:format("~s~n", [K]),
	D1 = dict:fetch(K, D),
	Keys = dict:fetch_keys(D1),
	Keys1 = lists:sort(Keys),
	print_word_stat(Keys1, D1),
	print(T, D);

print([], _) ->
	io:format("~n").

print_word_stat([Line|T], D) ->
	N = dict:fetch(Line, D),
	io:format("	~B: ~B~n", [Line, N]),
	print_word_stat(T, D);

print_word_stat([], _) ->
	io:format("~n").

