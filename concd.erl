#!/usr/bin/env escript

main([A]) ->
	conc_dict:main([A]);

main([]) ->
	io:format("usage: conct file~n").

