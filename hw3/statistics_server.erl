-module(statistics_server).
-behaviour(gen_server).
-export([start_link/0]).

-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVICE_NAME, {global, statistics_server}).

start_link() ->
  gen_server:start_link(?SERVICE_NAME, ?MODULE, [], []).

init([]) ->
  {ok, []}.

handle_call({mean, Values}, _, State) ->
  Result = statistics:mean(Values),
  gen_server:cast({global, history_server}, {add, mean, Result, Values}),
  {reply, Result, State};

handle_call({std_dev, Values}, _, State) ->
  Result = statistics:std_dev(Values),
  gen_server:cast({global, history_server}, {add, std_dev, Result, Values}),
  {reply, Result, State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

