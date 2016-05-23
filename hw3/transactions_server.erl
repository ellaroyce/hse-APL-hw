-module(transactions_server).
-behaviour(gen_server).
-export([start_link/0,
               stop/0,
               init/1,
        handle_call/3,
        handle_cast/2,
        handle_info/2,
          terminate/2,
        code_change/3]).

%  идеи взяты из http://yzh44yzh.by/post/gen_server.html

-define(SERVER, {global, transactions_server}).

handle_call(history, _, State)      -> Result = State, NewState = State, {reply, Result, NewState};

handle_call(_Request, _From, State) -> {reply, ok, State}.

handle_cast(stop, _State)           -> dets:close(historyOfTransactions), {stop, normal, _State} ;

handle_cast(clear, _State)          -> dets:insert(historyOfTransactions, {history, []}), {noreply, []};

handle_cast({withdraw, Amount}, State)      ->
  NewState = lists:append(State, [Amount]),
  dets:insert(historyOfTransactions, {history, NewState}),
  {noreply, NewState};

handle_cast(_Request, State)                -> {noreply, State}.

code_change(_OldVsn, State, _Extra)         -> {ok, State}.

handle_info({'EXIT', _Pid, _Reason}, State) -> dets:close(historyOfTransactions), {noreply, State};

handle_info(_Info, State)   -> {noreply, State}.

terminate(_Reason, _State)  ->  dets:close(historyOfTransactions), ok.

start_link()    -> gen_server:start_link(?SERVER, ?MODULE, [], []).

stop()          -> gen_server:cast(?MODULE, stop).

init([])        ->
  dets:open_file(historyOfTransactions, [{type, set}]),
  InitState =
%  скопировано из http://erlang.org/doc/efficiency_guide/tablesDatabases.html
% http://erlang.org/doc/man/dets.html
% HOT = History Of Transactions
  case dets:first(historyOfTransactions) of
    '$end_of_table' -> [];
    history -> [{history, HOT}] = dets:lookup(historyOfTransactions, history), HOT
  end,
  process_flag(trap_exit, true),
  {ok, InitState}.