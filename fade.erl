#!/usr/bin/env escript

%% This script decolorizes files by removing color related escape sequences.

main([Infile, Outfile]) ->
	fade(Infile, Outfile);

main(_) ->
	io:format("usage: fade.erl infile outfile~n").

fade(Infile, Outfile) ->
	{ok, D} = file:read_file(Infile),
	P = re:replace(D, "\033\\[(\\d{1,2};)?\\d{0,2}m", "", [{return, list}, global]),
	file:write_file(Outfile, P).

