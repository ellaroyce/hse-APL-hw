-module(check_winner).
-export([cw/5]).
%идея взята с https://habrahabr.ru/post/146698/

cw(MovesX, MovesY, {X,Y}, {X2, Y2}, check_bot)        -> case check_win(MovesY, {X2,Y2}) of  true -> bot_win; false     -> cw(MovesX, MovesY, {X,Y}, {X2, Y2}, check_draw) end;
cw(_MovesX, MovesY, {_X,_Y}, {_X2, _Y2}, check_draw)  -> case length(MovesY) == 50 of  true -> draw; false              -> next end;
cw(MovesX, MovesY, {X,Y}, {X2, Y2}, [])               -> case check_win(MovesX, {X,Y}) of  true -> player_win; false    -> cw(MovesX, MovesY, {X,Y}, {X2, Y2}, check_bot) end.

checkHR(_MovesList, {_X,_Y}, false) -> -1;
checkHR(MovesList, {X,Y}, true)     -> NextX = X + 1, 1 + checkHR(MovesList, {NextX, Y}, internal:exist_in_list(MovesList, {NextX, Y})).
checkHL(_MovesList, {_X,_Y}, false) -> -1;
checkHL(MovesList, {X,Y}, true)     -> NextX = X - 1, 1 + checkHL(MovesList, {NextX, Y}, internal:exist_in_list(MovesList, {NextX, Y})).
checkVU(_MovesList, {_X,_Y}, false) -> -1;
checkVU(MovesList, {X,Y}, true)     ->  NextY = Y + 1, 1 + checkVU(MovesList, {X, NextY}, internal:exist_in_list(MovesList, {X, NextY})).
checkVD(_MovesList, {_X,_Y}, false) -> -1;
checkVD(MovesList, {X,Y}, true)     ->  NextY = Y - 1, 1 + checkVD(MovesList, {X, NextY}, internal:exist_in_list(MovesList, {X, NextY})).
checkFDU(_MovesList, {_X,_Y}, false)-> -1;
checkFDU(MovesList, {X,Y}, true)    -> NextX = X + 1, NextY = Y + 1, 1 + checkFDU(MovesList, {NextX, NextY}, internal:exist_in_list(MovesList, {NextX, NextY})).
checkFDD(_MovesList, {_X,_Y}, false)-> -1;
checkFDD(MovesList, {X,Y}, true)    -> NextX = X - 1, NextY = Y - 1, 1 + checkFDD(MovesList, {NextX, NextY}, internal:exist_in_list(MovesList, {NextX, NextY})).
checkSDU(_MovesList, {_X,_Y}, false)-> -1;
checkSDU(MovesList, {X,Y}, true)    ->  NextX = X - 1, NextY = Y + 1, 1 + checkSDU(MovesList, {NextX, NextY}, internal:exist_in_list(MovesList, {NextX, NextY})).
checkSDD(_MovesList, {_X,_Y}, false)-> -1;
checkSDD(MovesList, {X,Y}, true)    ->  NextX = X + 1, NextY = Y - 1, 1 + checkSDD(MovesList, {NextX, NextY}, internal:exist_in_list(MovesList, {NextX, NextY})).

check_win(MoveList, LastMove)                   -> check_win(MoveList, LastMove, horizontal, 0).
check_win(_MoveList, _LastMove, _, 5)           -> true;
check_win(_MoveList, _LastMove, finish, _)      -> false;
check_win(MoveList, LastMove, fdiagonal, _)     -> FDiagonal = checkFDU(MoveList, LastMove, true) + checkFDD(MoveList, LastMove, true) + 1, check_win(MoveList, LastMove, sdiagonal, FDiagonal);
check_win(MoveList, LastMove, vertical, _)      -> Vertical = checkVU(MoveList, LastMove, true) + checkVD(MoveList, LastMove, true) + 1,    check_win(MoveList, LastMove, fdiagonal, Vertical);
check_win(MoveList, LastMove, horizontal, _)    -> Horizontal = checkHR(MoveList, LastMove, true) + checkHL(MoveList, LastMove, true) + 1,  check_win(MoveList, LastMove, vertical, Horizontal);
check_win(MoveList, LastMove, sdiagonal, _)     -> SDiagonal = checkSDU(MoveList, LastMove, true) + checkSDD(MoveList, LastMove, true) + 1, check_win(MoveList, LastMove, finish, SDiagonal).