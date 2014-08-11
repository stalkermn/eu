%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. июл 2014 18:50
%%%-------------------------------------------------------------------
-module(eu_conveyor).
-author("protoj").

-include("conveyor_h.hrl").
%% API
-export([term_to_conv_req_records/1, to_conv_resp_term/1, reqObj2respObj/2]).



term_to_conv_req_records([{<<"ops">>, Operations}]) ->
      try
          [operation_term_to_conv_reqObj(Oper)  || Oper <- Operations]
      catch
          {error, Reason} -> {error, Reason}
      end.



to_conv_resp_term(#conveyor_api_response_event{} = RespObj)->
       to_conv_resp_term([RespObj]);
to_conv_resp_term([O | _]= Objs) when is_record(O, conveyor_api_response_event)->
       [
         {<<"request_proc">>, <<"ok">>},
         {<<"ops">>,
         [operationRespTerm(Obj) || Obj <-Objs]
       }].


reqObj2respObj(ReqObj, ResponseData) when is_record(ReqObj, conveyor_api_request_event) ->
        #conveyor_api_response_event{
          data = ResponseData,
          obj_id = ReqObj#conveyor_api_request_event.obj_id,
          state = <<"ok">>,
          unique_ref = ReqObj#conveyor_api_request_event.unique_ref
        }.


operationRespTerm(#conveyor_api_response_event{data = Data, obj_id = ObjID, state = State, unique_ref = Ref})->
      [
        {<<"ref">>, Ref},
        {<<"obj_id">>, ObjID},
        {<<"proc">>, State},
        {<<"res_data">>, Data}
      ].



operation_term_to_conv_reqObj(OperationTerm)->
      #conveyor_api_request_event{
        obj_id = eu:is_undef(proplists:get_value(?objIdTagName, OperationTerm)),
        conv_id = eu:is_undef(proplists:get_value(?convIdTagName, OperationTerm)),
        data = eu:is_undef(proplists:get_value(?dataTagName, OperationTerm)),
        extra = eu:is_undef(proplists:get_value(?extraTagName, OperationTerm)),
        operation_type = eu:is_undef(proplists:get_value(?extraTagName, OperationTerm, <<"undefined">>)),
        unique_ref = eu:is_undef(proplists:get_value(?refTagName, OperationTerm))
      }.

