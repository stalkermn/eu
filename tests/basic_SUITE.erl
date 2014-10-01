%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. окт 2014 20:29
%%%-------------------------------------------------------------------
-module(basic_SUITE).
-author("protoj").


-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

%% API

all()->
%%   all tests are there
  [

  ].

init_per_suite(Config) ->
  % действия, выполняемые перед запуском набора тестов
  Config.

init_per_testcase(_, Config) ->
  % действия, выполняемые перед запуском теста
  Config.

end_per_testcase(_, Config) ->
  % действия, выполняемые после завершения теста
  Config.

end_per_suite(Config) ->
  % действия, выполняемые после завершения всего набора тестов
  Config.
  

test_eu_module()->
  test_is_undef_arrity1(),
  test_is_undef_arrity2().

%%   test_is_empty_arrity1(),
%%   test_is_empty_arrity2().


test_is_undef_arrity2() ->
  Undef = undefined,
  NotUndefined1 = <<"">>,
  NotUndefined2 = [],
  NotUndefined3 = 132,
  NotUndefined4 = 132.0,
  NotUndefined5 = {},

  UndefFieldName = <<"undefined">>,
  ?assertThrow({error, <<"undefined_value in field ", UndefFieldName/binary>>}, eu:is_undef(UndefFieldName, Undef)),
  ?assertEqual(NotUndefined1, eu:is_undef(UndefFieldName, NotUndefined1)),
  ?assertEqual(NotUndefined2, eu:is_undef(UndefFieldName, NotUndefined2)),
  ?assertEqual(NotUndefined3, eu:is_undef(UndefFieldName, NotUndefined3)),
  ?assertEqual(NotUndefined4, eu:is_undef(UndefFieldName, NotUndefined4)),
  ?assertEqual(NotUndefined5, eu:is_undef(UndefFieldName, NotUndefined5)).

test_is_undef_arrity1() ->
  Undef = undefined,
  NotUndefined1 = <<"">>,
  NotUndefined2 = [],
  NotUndefined3 = 132,
  NotUndefined4 = 132.0,
  NotUndefined5 = {},

  ?assertThrow({error, undefined_value}, eu:is_undef(Undef)),
  ?assertEqual(NotUndefined1, eu:is_undef(NotUndefined1)),
  ?assertEqual(NotUndefined2, eu:is_undef(NotUndefined2)),
  ?assertEqual(NotUndefined3, eu:is_undef(NotUndefined3)),
  ?assertEqual(NotUndefined4, eu:is_undef(NotUndefined4)),
  ?assertEqual(NotUndefined5, eu:is_undef(NotUndefined5)).

%% test_is_empty_arrity2() ->
%%   error(not_implemented).
%%
%% test_is_empty_arrity1() ->
%%   error(not_implemented).
