%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. июн 2014 09:33
%%%-------------------------------------------------------------------
-module(eu_proc).
-author("protoj").

%% API
-export([wait/1]).



wait(Sec) -> receive after (1000 * Sec) -> ok end.