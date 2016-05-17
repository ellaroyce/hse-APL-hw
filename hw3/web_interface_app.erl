%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(web_interface_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, web_interface, "index.html"}},
            {"/history", toppage_handler, []},
			{"/[...]", cowboy_static, {priv_dir, web_interface, "",
				[{mimetypes, cow_mimetypes, all}]}}
		]}
	]),
    PortNumber = application:get_env(web_interface, port, 8080),
	{ok, _} = cowboy:start_http(http, 100, [{port, PortNumber}], [
		{env, [{dispatch, Dispatch}]}
	]),
	web_interface_sup:start_link().

stop(_State) ->
	ok.
