#!/usr/bin/env escript

main([A]) ->
	conc:main([A]);

main([]) ->
	io:format("usage: conct file~n").

