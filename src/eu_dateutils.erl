%%%-------------------------------------------------------------------
%%% @author protoj
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. июн 2014 17:10
%%%-------------------------------------------------------------------
-module(eu_dateutils).
-author("protoj").

%% API
-export([
  trim_date/2,
  to_gregorian_days_from_binary/1,
  compare_bin_dates/2,
  iso_date_time_to_binary/1,
  iso_date_time_with_timezone_to_binary/2,
  to_string_datetime/1,
  get_hour_shift/1,
  get_time_zone/1,
  unixtimeToDateTime/1,
  next_date_by_period/2,
  add_days/2,
  add_hours/2,
  get_next_datetime_by/3,
  add_year/2,
  add_minutes/2,
  date_to_list/4,
  date_to_list/3,
  to_date_from_binary/1,
  first_date_last_month/1,
  final_date_last_month/1,
  current_timezone/0
  , microtime/0, timestamp/0, time/0, now_in_date_time/0, unixtime/0]).


-define(DAYS_IN_WEEK, 7).

-type(datetimebin() :: binary()).
-type(datetimestring() :: string()).

%% if datatype calendar:datetime() -> will converted to YYYY-MM-DD HHHH-MM-SS and trim this format by CountedSybmols
-spec trim_date(Date, CountOfSymbols) -> TrimmedDate when
  Date :: calendar:datetime() | datetimebin() | datetimestring(),
  CountOfSymbols :: integer(),
  TrimmedDate :: datetimestring().
trim_date(Date, Count) when is_binary(Date)-> trim_date(eu_types:to_list(Date), Count);
trim_date(Date, Count) when is_list(Date)-> string:left(eu_types:to_list(Date), Count);
trim_date({_D, _T} = DT, Count) -> trim_date(iso_date_time_to_string(DT), Count);
trim_date(_DT, _Count) -> undefined.

%% Input param must been <<"YYYY_MM_DD">>
-spec to_date_from_binary(BinDate) -> Date when
  BinDate :: datetimebin(),
  Date    :: calendar:date().
to_date_from_binary(BinDate) when is_binary(BinDate) ->
  DateList = eu_types:to_list(BinDate),
  Year = list_to_integer(string:substr(DateList, 1, 4)),
  Month = list_to_integer(string:substr(DateList, 6, 2)),
  Day = list_to_integer(string:substr(DateList, 9, 2)),
  {Year, Month, Day}.

%% Input param must been <<"YYYY_MM_DD HH:MM:SS">>
-spec to_gregorian_days_from_binary(DateTimeBin) -> Days when
  DateTimeBin :: datetimebin(),
  Days :: non_neg_integer().
to_gregorian_days_from_binary(DateTimeBin) when is_binary(DateTimeBin)->
  {Date, _} = to_universal_erlang_datetime(eu_types:to_list(DateTimeBin), without_timezone),
  calendar:date_to_gregorian_days(Date).

%% This method are parse bin or string DATETIME value into {D, T} with or without shifting to current timezone (application timezone)
%% Input param must been <<"YYYY_MM_DD HH:MM:SS">> for without_timezone
%% Param OR YYYY_MM_DD HH:MM:SS+ZZ for locale second param
-spec to_universal_erlang_datetime(DateTimeL, LocaleFlag) -> DateTime when
  DateTimeL :: datetimebin() | datetimestring(),
  LocaleFlag :: without_timezone | locale,
  DateTime :: calendar:datetime() | {DateTimeLocale, Timezone},

    DateTimeLocale :: calendar:datetime(),
    Timezone :: string()
.
to_universal_erlang_datetime(Date_list, without_timezone) when is_list(Date_list) ->
  Year = list_to_integer(string:substr(Date_list, 1, 4)),
  Month = list_to_integer(string:substr(Date_list, 6, 2)),
  Day = list_to_integer(string:substr(Date_list, 9, 2)),

  H = list_to_integer(string:substr(Date_list, 12, 2)),
  M = list_to_integer(string:substr(Date_list, 15, 2)),
  S = list_to_integer(string:substr(Date_list, 18, 2)),
  {{Year, Month, Day},{H, M, S}};

to_universal_erlang_datetime(Date_list, locale) when is_list(Date_list) ->
  {to_universal_erlang_datetime(Date_list), get_time_zone(Date_list)}.

%% This function are return erlang datetime from string or binary DateTIME
%% Param OR YYYY_MM_DD HH:MM:SS+ZZ
-spec to_universal_erlang_datetime(DateTimeL)->DT when
  DateTimeL :: datetimebin() | datetimestring(),
  DT :: calendar:datetime().
to_universal_erlang_datetime(Date_list) when is_list(Date_list) ->
  Year = list_to_integer(string:substr(Date_list, 1, 4)),
  Month = list_to_integer(string:substr(Date_list, 6, 2)),
  Day = list_to_integer(string:substr(Date_list, 9, 2)),

  H = list_to_integer(string:substr(Date_list, 12, 2)),
  M = list_to_integer(string:substr(Date_list, 15, 2)),
  S = list_to_integer(string:substr(Date_list, 18, 2)),
  TimeZone = get_hour_shift(get_time_zone(Date_list)),

  Date = {{Year, Month, Day},{H, M, S}},
  ShiftedDate = shift_date_to_universal(Date, TimeZone),

  ShiftedDate
;
to_universal_erlang_datetime(undefined) -> undefined;
to_universal_erlang_datetime({_D, _T}= DT) -> DT;
to_universal_erlang_datetime(Date_list) ->
  to_universal_erlang_datetime(eu_types:to_list(Date_list)).

%% This fucntion return current application timezone
-spec current_timezone() -> Timezone when
  Timezone :: string().
current_timezone() ->
  Time = erlang:universaltime(),
  LocalTime = calendar:universal_time_to_local_time(Time),
  DiffSecs = calendar:datetime_to_gregorian_seconds(LocalTime) -
    calendar:datetime_to_gregorian_seconds(Time),
  lists:flatten(zone((DiffSecs/3600))).

zone(Val) when Val < 0 ->  io_lib:format("-~2..0w", [trunc(abs(Val))]);
zone(Val) when Val >= 0 -> io_lib:format("+~2..0w", [trunc(abs(Val))]).

shift_date_to_universal(DateTime, HourShift)->
  GSecs = calendar:datetime_to_gregorian_seconds(DateTime),
  HourShiftSec = 3600*HourShift,
  calendar:gregorian_seconds_to_datetime(GSecs - HourShiftSec).

shift_datetime_to_timezone({{Year,Month,Day},{Hour,Mins,Secs}}, HourShift)->
  GSecs = calendar:datetime_to_gregorian_seconds(
    {{Year,Month,Day},{Hour,Mins,eu_types:to_integer(Secs)}}
  ),
  HourShiftSec = 3600*HourShift,
  calendar:gregorian_seconds_to_datetime(GSecs + HourShiftSec).

-spec compare_bin_dates(BinDate1, BinDate2) -> boolean() when
  BinDate1 :: datetimebin(),
  BinDate2 :: datetimebin().
compare_bin_dates(BinDate1, BinDate2) ->
  {Date1, _} = to_universal_erlang_datetime(BinDate1),
  {Date2, _} = to_universal_erlang_datetime(BinDate2),
  calendar:date_to_gregorian_days(Date2) > calendar:date_to_gregorian_days(Date1)  .


-spec iso_date_time_with_timezone_tostring(DateTime, Timezone)-> datetimestring() when
  DateTime :: calendar:datetime(),
  Timezone :: string().
iso_date_time_with_timezone_tostring(DateTime, TimeZone) ->
  iso_date_time_to_string(shift_datetime_to_timezone(DateTime, TimeZone)).
iso_date_time_to_string({{Year, Mon, Day}, {Hour, Min, Sec}}) ->
  Args = [Year, Mon, Day, Hour, Min, eu_types:to_integer(Sec)],
  S = io_lib:format("~B-~2.10.0B-~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B", Args),
  lists:flatten(S).

-spec iso_date_time_to_binary(DateTime)-> datetimebin() when
  DateTime :: calendar:datetime().
iso_date_time_to_binary(DateTime)->
  eu_types:to_binary(iso_date_time_to_string(DateTime)).

-spec iso_date_time_with_timezone_to_binary(DateTime, Timezone)-> datetimebin() when
  DateTime :: calendar:datetime(),
  Timezone :: string().
iso_date_time_with_timezone_to_binary(null, _TimeZone)-> <<"null">>;
iso_date_time_with_timezone_to_binary(DateTime, TimeZone)->
  T = get_hour_shift(TimeZone),
  eu_types:to_binary(iso_date_time_with_timezone_tostring(DateTime, T))
.
%%     TO  1/16/2014 9:24:52 AM
to_string_datetime(DateList) when is_list(DateList)->
  {{Year, Month, Day}, {H, M, S}} = to_universal_erlang_datetime(DateList),
  AMPM =
    if
      H >= 12 -> " PM";
      true -> " AM"
    end,
  NM =
    if
      M < 10 ->
        "0" ++ eu_types:to_list(M);
      true ->
        eu_types:to_list(M)
    end,
  NS =
    if
      S < 10 ->
        "0" ++ eu_types:to_list(M);
      true ->
        eu_types:to_list(M)
    end,
  eu_types:to_list(Month) ++ "/" ++ eu_types:to_list(Day) ++ "/" ++ eu_types:to_list(Year) ++ " " ++
    eu_types:to_list(H) ++":" ++ NM ++ ":" ++ NS ++ AMPM.


%% for - ${INT} shifting
-spec get_hour_shift(datetimebin()) -> string().
get_hour_shift(Bin) when is_binary(Bin)-> get_hour_shift(eu_types:to_list(Bin));
get_hour_shift([45 | Value]) -> eu_types:to_integer(Value);
%% for + ${INT} shifting
get_hour_shift([43 | Value]) -> eu_types:to_integer(Value).

get_time_zone(<<"">>)-> "+00";
get_time_zone(undefined)-> "+00";
get_time_zone(null)-> "+00";
get_time_zone(<<"null">>)-> "+00";
get_time_zone(DateBin) when is_binary(DateBin)-> get_time_zone(eu_types:to_list(DateBin));
get_time_zone(DateList) when is_list(DateList)->
  case string:substr(DateList, 20, 3) of
    [] -> "+00";
    V -> V
  end.

-spec unixtimeToDateTime(Milliseconds) -> calendar:datetime() when Milliseconds :: non_neg_integer().
unixtimeToDateTime(Milliseconds) ->
  BaseDate      = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
  Seconds       = BaseDate + (Milliseconds div 1000),
  { Date,_Time} = calendar:gregorian_seconds_to_datetime(Seconds),
  Date.


-spec get_next_datetime_by(datetimebin(), Period, Count) -> calendar:datetime() | [calendar:datetime()] when
  Period :: days | week | month | years,
  Count :: non_neg_integer().
get_next_datetime_by(DT, Period, Count) when is_binary(DT)-> get_next_datetime_by(to_universal_erlang_datetime(DT), Period, Count);
get_next_datetime_by({_,_} = DateTimeFrom, years, Count)->
  lists:foldl(
    fun
      (_, BeforeDT) -> next_date_by_period(BeforeDT, month)
    end, DateTimeFrom, lists:seq(1, Count * 12));
get_next_datetime_by(DateTimeFrom, month = Period, Count)->
  lists:foldl(
    fun (_, BeforeDT) ->
      next_date_by_period(BeforeDT, Period)
    end, DateTimeFrom, lists:seq(1, Count));
get_next_datetime_by(DateTimeFrom, week, Count)->    add_days(DateTimeFrom, (Count * 7));
get_next_datetime_by(DateTimeFrom, days, Count)->    add_days(DateTimeFrom, Count);
get_next_datetime_by(DateTimeFrom, hours, Count)->   add_hours(DateTimeFrom, Count);
get_next_datetime_by(DateTimeFrom, minutes, Count)-> add_minutes(DateTimeFrom, Count);
get_next_datetime_by(DateTimeFrom, Period, Count)->
  lists:foldl(
    fun
      (_, BeforeDT) ->
        next_date_by_period(BeforeDT, Period)
    end, DateTimeFrom, lists:seq(1, Count)).


-spec next_date_by_period(DateTime, Period) -> NDateTime when
  DateTime :: calendar:datetime(),
  Period :: year | day | week | month,
  NDateTime :: calendar:datetime().
next_date_by_period(DT, year)  -> add_year(DT, 1);
next_date_by_period({Date, T}, week)  ->
  NextDate = add_days(Date, ?DAYS_IN_WEEK),
  {NextDate, T};
next_date_by_period({Date, T}, day)  ->
  NextDate = add_days(Date, 1),
  {NextDate, T};
next_date_by_period({{Y, M, _} = Date, T}, month)  ->
  Days = calendar:last_day_of_the_month(Y, M),
  NextDate = add_days(Date, Days),
  {NextDate, T}.

add_days({SourceDate, T}, ToAdd) ->
  UpDate = calendar:gregorian_days_to_date(
    calendar:date_to_gregorian_days(SourceDate) + ToAdd),
  {UpDate, T};
add_days(SourceDate, ToAdd) ->
  calendar:gregorian_days_to_date(
    calendar:date_to_gregorian_days(SourceDate) + ToAdd).

add_hours(Date, Hours)->
  Secs = calendar:datetime_to_gregorian_seconds(Date),
  NSecs = Secs + (3600 * Hours),
  calendar:gregorian_seconds_to_datetime(NSecs).

add_minutes(Date, Minutes)->
  Secs = calendar:datetime_to_gregorian_seconds(Date),
  NSecs = Secs + (60 * Minutes),
  calendar:gregorian_seconds_to_datetime(NSecs).

add_year({{YYYY, _, _}=D, T}, Count)->
  Days = calendar:date_to_gregorian_days(D),
  ResultDate = lists:foldl(
    fun(_, DaysD) ->
      DaysPerYear =
        case calendar:is_leap_year(YYYY) of
          true -> 366;
          _ -> 365
        end,
      DaysD + DaysPerYear
    end, Days, lists:seq(1, Count)),
  {calendar:gregorian_days_to_date(ResultDate), T}.
date_to_list(YY,MM,DD)->
  S = io_lib:format("~B_~2.10.0B_~2.10.0B", [YY, MM, DD]),
  lists:flatten(S).
date_to_list(YYY, MM, DD, Delimeter) ->
  S = io_lib:format("~B~w~2.10.0B~w~2.10.0B", [YYY, Delimeter, MM, Delimeter, DD]),
  lists:flatten(S).

first_date_last_month(N) ->
  {Year, Month, _Day} = date(),
  DaysInMonth = calendar:last_day_of_the_month(Year, Month-N),
  GregDaysLastDate = calendar:date_to_gregorian_days(final_date_last_month(N)),
  calendar:gregorian_days_to_date(GregDaysLastDate - (DaysInMonth - 1)).

final_date_last_month(N) ->
  {Year, Month, _Day} = date(),
  {Year, Month-N, calendar:last_day_of_the_month(Year, Month-N)}.

microtime()->
  timer:now_diff(now(), {0,0,0}).

timestamp()->
  microtime() / 1000.

%% get mictotime list
time()->
  integer_to_list( microtime() ).

now_in_date_time()->
  Now = now(),
  calendar:now_to_datetime(Now).

unixtime()->
  {A,B,_C} = now(),
  A*1000000 + B.
