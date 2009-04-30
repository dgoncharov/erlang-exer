-module(bubble_sort).
-export([bubble_sort/1]).

bubble_sort(L) ->
	bubble_sort(L, [], false).

bubble_sort([H1,H2|T], R, C) ->
	case H1 > H2 of
	true -> bubble_sort([H1|T], [H2|R], true);
	false -> bubble_sort([H2|T], [H1|R], C)
	end;

bubble_sort([H], R, C) -> bubble_sort([], [H|R], C);
bubble_sort([], R, true) -> bubble_sort(lists:reverse(R), [], false);
bubble_sort([], R, false) -> lists:reverse(R).

