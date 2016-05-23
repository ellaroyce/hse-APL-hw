-module(atm).
-export ([  sdown/1,
            sUp/1,
            obmen/4,
            withdraw/2]).

obmen(Amount, [CurBanknote | Rest], BanknotesNum, BanknotesList)
                            -> obmen(Amount, Rest, BanknotesNum, BanknotesList) ++ obmen(Amount - CurBanknote, Rest, BanknotesNum + 1, BanknotesList ++ [CurBanknote]);
obmen(0, [], BanknotesNum, BanknotesList)
                            -> [{BanknotesNum, BanknotesList}];
obmen(_Amount, [], _BanknotesNum, _BanknotesList)
                            -> [].

sUp([CurBnknt|Rst])         -> sUp([ X || X <- Rst, X < CurBnknt]) ++ [CurBnknt] ++ sUp([ X || X <- Rst, X >= CurBnknt]);       sUp([]) -> [].

sdown([CurBnknt|Rst])       -> sdown([ X || X <- Rst, X > CurBnknt]) ++ [CurBnknt] ++ sdown([ X || X <- Rst, X =< CurBnknt]); sdown([]) -> [].

withdraw(_Amount, [])       ->  exit(normal);

withdraw(Amount, Banknotes) ->
    Ret = sUp(obmen(Amount, Banknotes, 0, [])),
    if Ret == [] -> {request_another_amount, [], Banknotes};
    true -> [{_,Banks}|_] = Ret, {ok, sdown(Banks), Banknotes -- Banks}
    end.
