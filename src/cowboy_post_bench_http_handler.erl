-module(cowboy_post_bench_http_handler).

-ifdef(COWBOY1).

-behavior(cowboy_http_handler).
-export([init/3, handle/2, terminate/3]).

init({tcp, http}, Req0, _Opts) ->
    {ok, Req0, state}.

handle(Req0, State) ->
    execute(Req0, State).

method(Req0) -> cowboy_req:method(Req0).
path(Req0) -> cowboy_req:path(Req0).
reply(Code, Msg, Req0) -> cowboy_req:reply(Code, [{<<"content-type">>, <<"text/plain">>}], Msg, Req0).
body(Req0) -> cowboy_req:body(Req0).

-else.

-behavior(cowboy_handler).
-export([init/2, terminate/3]).

-spec init(cowboy_req:req(), _) -> {ok, cowboy_req:req(), _}.
init(Req0, _Opts) ->
    execute(Req0, state).

method(Req0) -> {cowboy_req:method(Req0), Req0}.
path(Req0) -> {cowboy_req:path(Req0), Req0}.
reply(Code, Msg, Req0) -> cowboy_req:reply(Code, #{<<"content-type">> => <<"text/plain">>}, Msg, Req0).
body(Req0) -> cowboy_req:read_body(Req0).

-endif.

terminate(_Reason, _Req, _State) ->
    ok.

execute(Req0, State) ->
    {Method, Req1} = method(Req0),
    {Path, Req2} = path(Req1),
    case {Method, Path} of
        {<<"GET">>, _} ->
            Req1 = reply(200, <<"ok", 16#d, 16#a>>, Req0),
            {ok, Req1, State};
        {<<"POST">>, <<"/quit">>} ->
            _ = quit(),
            Req3 = reply(200, <<"ok", 16#d, 16#a>>, Req2),
            {ok, Req3, State};
        {<<"POST">>, _} ->
            Req3 = measure(Path, Req2),
            {ok, Req4} = reply(200, <<"ok", 16#d, 16#a>>, Req3),
            {ok, Req4, State};
        _ ->
            {ok, Req3} = reply(405, <<"Method Not Allowed", 16#d, 16#a>>, Req2),
            {ok, Req3, State}
    end.

measure(Path, Req0) ->
    {DurationUs, {Size, Req1}} = timer:tc(fun() -> read_body_all(Req0, 0) end),
    _ = io:format("~s	~.3f	~p~n", [Path, DurationUs / 1000, Size]),
    Req1.

read_body_all(Req0, Size0) ->
    case body(Req0) of
        {Status, Body, Req1} ->
            Size1 = Size0 + byte_size(Body),
            case Status of
                ok -> {Size1, Req1};
                more -> read_body_all(Req1, Size1)
            end
    end.


quit() ->
    {ok, Pid} = application:get_env(cowboy_post_bench, control_pid),
    Pid ! quit,
    ok.
