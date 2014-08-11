-module(eu_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start/0, stop/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================
start()->application:start(eu).
start(_StartType, _StartArgs) -> {ok, self()}.
stop(_State) -> ok.

stop()->application:stop(eu).