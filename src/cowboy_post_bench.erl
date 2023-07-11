-module(cowboy_post_bench).

-export([main/1]).

-define(LISTENER, cowboy_post_bench_http_listener).

main(Args) ->
    Options0 = parse_args(Args),
    _ = io:format(standard_error, "~9999p~n", [Options0]),
    Options = Options0#{control_pid => self()},
    case Options of
        #{with_header := true} -> _ = io:format("path	ms	size~n");
        _ -> ok
    end,
    _ = error_logger:tty(false),
    {ok, Started} = application:ensure_all_started(cowboy_post_bench),
    _ = start_server(Options),
    _ = io:format(standard_error, "~s: start: port=~p~n", [?MODULE, maps:get(port, Options)]),
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
     {with_header, undefined, "with-header", undefined, "with header row"},
     {length, undefined, "length", {integer, 8000000}, "length parameter for cowboy_req:body (cowboy1) or cowboy_req:read_body (cowboy2)"},
     {initial_stream_flow_size, undefined, "initial-stream-flow-size", {integer, 65535}, "initial stream flow size parameter (cowboy2)"},
     {active_n, undefined, "active-n", {integer, 100}, "active N parameter (cowboy2)"},
     {so_buffer, undefined, "so-buffer", integer, "socket buffer (patched cowboy2)"}
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

start_server(Options = #{port := Port}) ->
    Dispatch = cowboy_router:compile([{'_', [{'_', cowboy_post_bench_http_handler, Options}]}]),
    {ok, _} = cowboy:start_http(?LISTENER, 8, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

-else.

start_server(Options = #{port := Port, active_n := ActiveN, initial_stream_flow_size := InitialStreamFlowSize}) ->
    Dispatch = cowboy_router:compile([{'_', [{'_', cowboy_post_bench_http_handler, Options}]}]),
    ProtocolOpts0 = #{env => #{dispatch => Dispatch},
                      active_n => ActiveN,
                      initial_stream_flow_size => InitialStreamFlowSize
                     },
    ProtocolOpts = case Options of
                       #{so_buffer := N} -> ProtocolOpts0#{so_buffer => N};
                       _ -> ProtocolOpts0
                   end,
    {ok, _} = cowboy:start_clear(?LISTENER, [{port, Port}], ProtocolOpts).

-endif.
