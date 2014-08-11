%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. июн 2014 09:31
%%%-------------------------------------------------------------------
-module(eu_lists).
-author("protoj").

%% API
-export([
  string_to_number/1,
  for/3,
  remove_duplicates/1]).


%% convert list or binary to float or integer
string_to_number(N) when is_binary(N)->
  binary_to_list(string_to_number(N));
string_to_number(N)->
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_Rest} -> F
  end.

for( Max, Max, F )  -> [ F(Max) ];
for( I, Max, F )    -> [ F(I) | for( I+1, Max, F ) ].

remove_duplicates([])    -> [];
remove_duplicates([H|T]) -> [H | [X || X <- remove_duplicates(T), X /= H]].