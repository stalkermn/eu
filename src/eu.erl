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
-include("eu_guards.hrl").
%% API
-export([is_undef/1, is_undef/2, is_empty/1, is_empty/2]).



is_undef(?Undef) ->
  throw({error, undefined_value});
is_undef(V) when ?IsNotUndef ->V.

is_undef(Field, ?Undef) ->
  FB = eu_types:to_binary(Field),
  throw({error, <<"undefined_value in field ", FB/binary>>});
is_undef(_Field, V) when ?IsNotUndef ->V;
is_undef(Field, _V) -> io:format("~p:is_undef -> unknown datatype for field ~p and val ~p", [?MODULE, Field, _V]).

is_empty(Val) when ?IsUndefOrEmpty(Val)  -> throw({error, empty_value});
is_empty(Value) -> Value.

is_empty(FB, Val) when ?IsUndefOrEmpty(Val) -> throw({error, <<"undefined_value in field ", FB/binary>>});
is_empty(_, Value) -> Value.