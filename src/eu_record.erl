%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. июн 2014 21:11
%%%-------------------------------------------------------------------
-module(eu_record).
-author("protoj").

%% API
-export([record_to_jsonterm/2, jsonterm_to_record/3]).




record_to_jsonterm(RecordFields , Record) when is_tuple(Record) andalso is_list(RecordFields) ->
  RecName = erlang:element(1, Record),
  case is_record(Record, RecName) of
    true ->
      Zipped = lists:zip(RecordFields, tl(tuple_to_list(Record))),
      eu_types:to_binary(Zipped );
    _ ->
      {error, "not a record"}
  end.

jsonterm_to_record(RecName, RecordFields, JsonTerm)->
%%   RecordFields = record_info(fields, RecName),
  list_to_tuple([RecName | [ FieldValue || FieldName <- RecordFields, FieldValue <- [ get_value(FieldName, JsonTerm)]  ] ]).

get_value( FieldName, JsonTerm ) when is_atom(FieldName) ->
  get_value(eu_types:to_binary(FieldName), JsonTerm);
get_value( FieldName, JsonTerm ) when is_binary(FieldName)->
  proplists:get_value(FieldName, JsonTerm).
