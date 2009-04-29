-module(index).
-export([index/2]).

index(L, X) -> index(L, X, 0).

index([H|_], H, I) -> I;
index([H|T], X, I) -> index(T, X, I + 1);
index([], _, I) -> -1.

