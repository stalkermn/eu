%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. июл 2014 11:19
%%%-------------------------------------------------------------------
-module(eu).
-author("protoj").

%% API
-export([is_undef/1, is_undef/2, is_empty/1, is_empty/2]).
-define(UNDEF, undefined).


is_undef(?UNDEF) ->
  throw({error, undefined_value});
is_undef(V) when is_binary(V)
  orelse is_integer(V)
  orelse is_boolean(V)
  orelse is_float(V)
  orelse is_atom(V)
  orelse is_list(V)
  orelse is_tuple(V) ->V;
is_undef(_V) -> io:format("~p:is_undef -> unknown datatype for val ~p", [?MODULE, _V]).

is_undef(Field, ?UNDEF) ->
  FB = eu_types:to_binary(Field),
  throw({error, <<"undefined_value in field ", FB/binary>>});
is_undef(_Field, V) when is_binary(V)
  orelse is_integer(V)
  orelse is_boolean(V)
  orelse is_float(V)
  orelse is_atom(V)
  orelse is_list(V)
  orelse is_tuple(V) ->V;
is_undef(Field, _V) -> io:format("~p:is_undef -> unknown datatype for field ~p and val ~p", [?MODULE, Field, _V]).

is_empty([]) ->
  throw({error, empty_value});
is_empty(<<>>) ->
  throw({error, empty_value});
is_empty(?UNDEF) ->
  throw({error, empty_value});
is_empty(Value) -> Value.

is_empty(FB, <<>>) ->
  throw({error, <<"undefined_value in field ", FB/binary>>});
is_empty(FB, []) ->
  throw({error, <<"undefined_value in field ", FB/binary>>});
is_empty(FB, ?UNDEF) ->
  throw({error, <<"undefined_value in field ", FB/binary>>});
is_empty(_, Value) -> Value.