%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. окт 2014 20:18
%%%-------------------------------------------------------------------
-author("protoj").
-define(IsNotUndef, is_binary(V)
  orelse is_integer(V)
  orelse is_boolean(V)
  orelse is_float(V)
  orelse is_atom(V)
  orelse is_list(V)
  orelse is_tuple(V)).

-define(Undef, undefined).

-define(IsUndefOrEmpty(Value), Value =:= <<>> orelse  Value =:= [] orelse Value =:= ?Undef).
-define(IsNotEmpty(V), false =:= (?IsUndefOrEmpty(V))).