%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. июн 2014 09:26
%%%-------------------------------------------------------------------
-module(eu_crypto).
-author("protoj").

%% API
-export([sha1/1, md5/1, binary_to_hex/1]).


sha1(Bin) when is_binary(Bin) -> bin_to_hexstr( crypto:hash(sha, Bin) ).

bin_to_hexstr(Bin) -> binary_to_hex(Bin).

md5(Bin) -> binary_to_hex(crypto:hash(md5, Bin)).

binary_to_hex(Bin) ->
  lists:foldl(
    fun (E, Acc) ->
        [hex(E bsr 4) | [hex(E band 16#F) | Acc]]
    end, [], lists:reverse(binary_to_list(Bin))).

hex(V) ->
  if
    V < 10 ->
      $0 + V;
    true ->
      $a + (V - 10)
  end.