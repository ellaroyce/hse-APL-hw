-module(statistics).
-export([mean/1, std_dev/1]).

mean(Values) ->
  Scale = 1 / length(Values),
  Acc = 0,
  F = fun(X,Y) -> X + Y end,
  Summ = lists:foldl(F,Acc,Values),
  Scale * Summ.

std_dev(Values) ->
  Mean = mean(Values),
  Squares = lists:map(fun(X) -> (X-Mean)*(X-Mean) end, Values),
  Sum = lists:foldl(fun(X,Y) -> X + Y end,0,Squares),
  math:sqrt(1/(length(Values)-1) * Sum).


