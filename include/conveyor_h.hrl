%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. июл 2014 11:06
%%%-------------------------------------------------------------------
-author("protoj").


-record(conveyor_api_request_event, {unique_ref, conv_id, obj_id, extra, operation_type, data}).

-record(conveyor_api_response_event, {state = <<"">>, unique_ref = <<"">>, obj_id = <<"">>, data = <<"">>}).

-define(convIdTagName, <<"conv_id">>).
-define(dataTagName, <<"data">>).
-define(objIdTagName, <<"obj_id">>).
-define(refTagName, <<"ref">>).
-define(extraTagName, <<"extra">>).

