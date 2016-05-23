-module(atm_server).
-behaviour(gen_server).
-export([start_link/0,
                init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
           terminate/2,
        code_change/3]).

%  идеи взяты из http://yzh44yzh.by/post/gen_server.html

-define(SERVER, {global, atm_server}).

handle_call({withdraw, Amount}, _, State)       ->
  {Status, Result, Rest} = atm:withdraw(Amount, State),
  if
    Status == ok -> gen_server:cast({global, transactions_server}, {withdraw, Amount});
    true -> do_nothing
  end,
  {reply, {Status, Result}, Rest};

handle_call(_Request, _From, State)             -> {reply, ok, State}.

handle_cast(_Request, State)    -> {noreply, State}.

handle_info(_Info, State)       -> {noreply, State}.

terminate(_Reason, _State)      -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

start_link()    -> gen_server:start_link(?SERVER, ?MODULE, [], []).

init([])        -> InitState = [5000, 50, 50, 50, 1000, 5000, 1000, 500, 100], {ok, InitState}.