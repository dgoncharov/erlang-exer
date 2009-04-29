-module(merge_sort).
-export([merge_sort/1]).

split([H|T]) -> split([H], T);
split([]) -> {[], []}.

split(L, [H|T]) ->
	case length(L) < length(T) of
	true ->	split([H|L], T);
	false -> {lists:reverse(L), [H|T]}
	end;

split(L, []) -> {L, []}.

merge([H1|T1], [H2|T2]) ->
	case H1 < H2 of
	true -> [H1|merge(T1,[H2|T2])];
	false -> [H2|merge([H1|T1], T2)]
	end;

merge([], L) -> L;
merge(L, []) -> L.


merge_sort([H]) -> [H];

merge_sort([]) -> [];

merge_sort(L) ->
	{A, B} = split(L),
	A1 = merge_sort(A),
	B1 = merge_sort(B),
	merge(A1, B1).

