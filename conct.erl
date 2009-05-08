#!/usr/bin/env escript

main([A]) ->
	R = conc:conc(A),
	io:format("~p~n", [R]);

main([]) ->
	io:format("usage: conct file~n").

