-module(selection_sort).
-export([selection_sort/1]).

selection_sort(L) -> lists:reverse(selection_sort(L, [])).

selection_sort([H1], R) -> [H1|R];

selection_sort([], R) -> R;

selection_sort(L, R) ->
	[Min|T] = min_elem_first(L, []),
	selection_sort(T, [Min|R]).

min_elem_first([H],R) -> [H|R];
min_elem_first([], R) -> R;

min_elem_first([H1,H2|T], R) ->
	case H1 < H2 of
	true -> min_elem_first([H1|T],[H2|R]);
	false -> min_elem_first([H2|T], [H1|R])
	end;

min_elem_first([H1|H2], R) ->
	case H1 < H2 of
	true -> [H1,H2|R];
	false -> [H2, H1|R]
	end.

