%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. июн 2014 20:00
%%%-------------------------------------------------------------------
-module(eu_string).
-author("protoj").

%% API
-export([is_start_with/3]).


is_start_with(SourceString, CountOfStartCharacters, StringToEqual) ->
  TrimmedSourceString = string:left(SourceString, CountOfStartCharacters),
  string:equal(TrimmedSourceString, StringToEqual).