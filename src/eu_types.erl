%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. июн 2014 09:29
%%%-------------------------------------------------------------------
-module(eu_types).
-author("protoj").

%% API
-export([to_float/1, to_list/1, to_binary/1, to_integer/1]).

to_float(Value) when is_list(Value)-> list_to_float(Value);
to_float(Value) when is_binary(Value)-> to_float(binary_to_list(Value));
to_float(Value) when is_integer(Value)-> Value + 0.0 ;
to_float(Value) when is_float(Value)-> Value.


to_list(undefined = V) ->atom_to_list(V);
to_list(Tuple) when is_tuple(Tuple)->tuple_to_list(Tuple);
to_list(null)->"null";
to_list([Tuple | PropList]) when is_list(PropList) and is_tuple(Tuple)->
  lists:map(fun({K,V})->
    {to_list(K), to_list(V)}
  end, [Tuple | PropList]);
to_list(Value) when is_list(Value)-> Value;
to_list(Value) when is_binary(Value)-> binary_to_list(Value);
to_list(Value) when is_integer(Value)-> integer_to_list(Value);
to_list(Value) when is_float(Value)-> float_to_list(Value);
to_list(Value) when is_atom(Value)-> atom_to_list(Value).

to_binary(T) when is_binary(T)-> T;
to_binary(T) when is_integer(T)-> to_binary(integer_to_list(T));
to_binary([Tuple | PropList] =L) when is_list(PropList) and is_tuple(Tuple)->
  lists:map(fun({K,V})->
    {to_binary(K), to_binary(V)}
  end, L);
to_binary(T) when is_list(T)-> list_to_binary(T);
to_binary(T) when is_float(T)-> to_binary(float_to_list(T));
to_binary(T) when is_atom(T)-> to_binary(atom_to_list(T)).

to_integer(undefined)-> undefined;
to_integer(T) when is_float(T)-> trunc(T);
to_integer(T) when is_integer(T)-> T;
to_integer(T) when is_list(T)-> list_to_integer(T);
to_integer(T) when is_binary(T)-> binary_to_integer(T);
to_integer(T) when is_tuple(T)-> to_integer(tuple_to_list(T)).
