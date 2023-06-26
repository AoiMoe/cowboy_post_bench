-module(cowboy_post_bench).

-export([main/1]).

-define(LISTENER, cowboy_post_bench_http_listener).

main(Args) ->
    Options = parse_args(Args),
    _ = application:set_env(cowboy_post_bench, control_pid, self()),
    case Options of
        #{with_header := true} -> _ = io:format("path	ms	size~n");
        _ -> ok
    end,
    _ = error_logger:tty(false),
    {ok, Started} = application:ensure_all_started(cowboy_post_bench),
    Port = maps:get(port, Options),
    _ = start_server(Port),
    _ = io:format(standard_error, "~s: start: port=~p~n", [?MODULE, Port]),
    _ = receive quit -> ok end,
    _ = timer:sleep(1000),
    _ = io:format(standard_error, "~s: quit ... ", [?MODULE]),
    _ = cowboy:stop_listener(?LISTENER),
    _ = lists:foreach(fun application:stop/1, lists:reverse(Started)),
    _ = io:format(standard_error, "done~n", []),
    _ = halt(0).

args_spec() ->
    [
     {port, $p, "port", {integer, 11111}, "port to listen"},
     {with_header, undefined, "with-header", undefined, "with header row"}
    ].

show_usage() ->
    getopt:usage(args_spec(), escript:script_name()).

parse_args(Args) ->
    case getopt:parse(args_spec(), Args) of
        {ok, {Options, []}} ->
            maps:from_list(lists:map(fun(X) when is_atom(X) -> {X, true}; (X) -> X end, Options));
        Ret ->
            case Ret of
                {ok, {_, UnexpectedArgs}} ->
                    _ = io:format(standard_error, "error: unexpected args: ~p~n~n", [UnexpectedArgs]);
                {error, {Reason, Data}} ->
                    _ = io:format(standard_error, "error: ~p: ~p~n~n", [Reason, Data])
            end,
            show_usage(),
            _ = halt(1)
    end.

-ifdef(COWBOY1).

start_server(Port) ->
    Dispatch = cowboy_router:compile([{'_', [{'_', cowboy_post_bench_http_handler, []}]}]),
    {ok, _} = cowboy:start_http(?LISTENER, 8, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

-else.

start_server(Port) ->
    Dispatch = cowboy_router:compile([{'_', [{'_', cowboy_post_bench_http_handler, []}]}]),
    {ok, _} = cowboy:start_clear(?LISTENER, [{port, Port}], #{env => #{dispatch => Dispatch}}).

-endif.
