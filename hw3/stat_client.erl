-module(stat_client).
-export([main/1]).

mean(Values) -> gen_server:call({global, statistics_server}, {mean, Values}).
std_dev(Values) -> gen_server:call({global, statistics_server}, {std_dev, Values}).
history() -> gen_server:call({global, history_server}, history).
clear_history() -> gen_server:cast({global, history_server}, clear_history).

print(Something) -> io:format("~p~n", [Something]).
convert(Strings) -> lists:map(fun(X)->list_to_integer(X) end, Strings).

run_command(["mean"|Values]) -> print(mean(convert(Values)));
run_command(["std_dev"|Values]) -> print(std_dev(convert(Values)));
run_command(["history"]) -> print(history());
run_command(["clear_history"]) -> clear_history();
run_command(_) -> io:format("No valid command provided!~n").

client_name(ServerName) ->
    InstanceName = "escript_client", % might be some random
    {HostName, NameType} = case string:str(ServerName, ".") of
                               0 -> {"localhost", shortnames};
                               _ -> {"127.0.0.1", longnames}
                           end,
    FullName = InstanceName ++ "@" ++ HostName,
    [list_to_atom(FullName), NameType].                                                                     

main([Host,Cookie|Command]) ->
  net_kernel:start(client_name(Host)),
  erlang:set_cookie(node(), list_to_atom(Cookie)),
  net_kernel:connect_node(list_to_atom(Host)),
  global:sync(),
  run_command(Command)
;
main(_) -> io:format("Usage: .... ~n").

