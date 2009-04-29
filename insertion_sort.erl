-module(insertion_sort).
-export([insertion_sort/1]).

insertion_sort([]) -> [];

insertion_sort([H]) -> [H];

insertion_sort([H|T]) ->
	[H2|T2] = insertion_sort(T),
	case H2 < H of
	true -> [H2|insertion_sort([H|T2])];
	false -> [H,H2|T2]
	end.

