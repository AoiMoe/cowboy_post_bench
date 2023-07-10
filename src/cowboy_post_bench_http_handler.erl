-module(cowboy_post_bench_http_handler).

-ifdef(COWBOY1).

-behavior(cowboy_http_handler).
-export([init/3, handle/2, terminate/3]).

init({tcp, http}, Req0, Options) ->
    {ok, Req0, Options}.

handle(Req0, Options) ->
    execute(Req0, Options).

method(Req0) -> cowboy_req:method(Req0).
path(Req0) -> cowboy_req:path(Req0).
reply(Code, Msg, Req0) -> cowboy_req:reply(Code, [{<<"content-type">>, <<"text/plain">>}], Msg, Req0).
body(Req0, Options) -> cowboy_req:body(Req0, [{length, maps:get(length, Options)}]).

-else.

-behavior(cowboy_handler).
-export([init/2, terminate/3]).

init(Req0, Options) ->
    execute(Req0, Options).

method(Req0) -> {cowboy_req:method(Req0), Req0}.
path(Req0) -> {cowboy_req:path(Req0), Req0}.
reply(Code, Msg, Req0) -> cowboy_req:reply(Code, #{<<"content-type">> => <<"text/plain">>}, Msg, Req0).
body(Req0, Options) -> cowboy_req:read_body(Req0, #{length => maps:get(length, Options)}).

-endif.

terminate(_Reason, _Req, _State) ->
    ok.

execute(Req0, Options) ->
    {Method, Req1} = method(Req0),
    {Path, Req2} = path(Req1),
    case {Method, Path} of
        {<<"GET">>, _} ->
            Req1 = reply(200, <<"ok", 16#d, 16#a>>, Req0),
            {ok, Req1, Options};
        {<<"POST">>, <<"/quit">>} ->
            maps:get(control_pid, Options) ! quit,
            Req3 = reply(200, <<"ok", 16#d, 16#a>>, Req2),
            {ok, Req3, Options};
        {<<"POST">>, _} ->
            Req3 = measure(Path, Options, Req2),
            {ok, Req4} = reply(200, <<"ok", 16#d, 16#a>>, Req3),
            {ok, Req4, Options};
        _ ->
            {ok, Req3} = reply(405, <<"Method Not Allowed", 16#d, 16#a>>, Req2),
            {ok, Req3, Options}
    end.

measure(Path, Options, Req0) ->
    {DurationUs, {Size, Req1}} = timer:tc(fun() -> read_body_all(Req0, Options, 0) end),
    _ = io:format("~s	~.3f	~p~n", [Path, DurationUs / 1000, Size]),
    Req1.

read_body_all(Req0, Options, Size0) ->
    case body(Req0, Options) of
        {Status, Body, Req1} ->
            Size1 = Size0 + byte_size(Body),
            case Status of
                ok -> {Size1, Req1};
                more -> read_body_all(Req1, Options, Size1)
            end
    end.
