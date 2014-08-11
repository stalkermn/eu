%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. июн 2014 11:17
%%%-------------------------------------------------------------------
-module(eu_config).
-author("protoj").

%% API
-export([load/1, get/2, get/3]).


% load config
load(FileName) when is_list(FileName)->
  load(list_to_binary(FileName));
load(FileName)->
  {ok, Config} = file:consult(FileName),
  Config.


% get config param
get(Config, Name)->
  get(Config, Name, undefined).
get(Config, Name, Key)->
  case proplists:lookup(Name, Config) of
    none        ->
      undefined;
    {Name, List}->
      case Key of
        undefined -> List;
        _  ->
          case proplists:lookup(Key, List) of
            none        ->
              undefined;
            {certfile, Value} ->
              binary_to_list(Value);
            {keyfile, Value} ->
              binary_to_list(Value);
            {cacertfile, Value} ->
              binary_to_list(Value);
            {sslpassword, Value} ->
              binary_to_list(Value);
            {Key, Value}->
              Value
          end
      end
  end.