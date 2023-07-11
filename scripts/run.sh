#! /bin/sh

usage() {
    echo "usage: $0 [--length=length] [--active-n=active-n] [--so-buffer=so-buffer] <version> <size> <times>" >&2
    exit 1
}

args=$(/usr/bin/getopt -l length:,active-n:,port:,so-buffer: "" $*) || usage
eval "set -- $args"

base_filename_appendix=""
opts=""
port=11111
while test $# -gt 0; do
    case $1 in
        --length | --active-n | --so-buffer)
            opts="${opts}$1 $2 "
            base_filename_appendix="${base_filename_appendix}${1#-}$2"
            shift 2
            ;;
        --port)
            port=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo error: something bad: "$*" >&2
            exit 1
    esac
done
opts="${opts}--port=$port "

version=$1
size=$2
times=$3

test -z "$version" -o -z "$size" -o -z "$times" && usage

base_filename=$version-$size-$times$base_filename_appendix

echo running for cowboy-$version, size=$size, ${times}times >&2
resultdir=${RESULTDIR:-result}
data_file=$resultdir/tmp-${base_filename}.dat
result_file=$resultdir/result-${base_filename}.tsv
curl_log_file=$resultdir/curl-log-${base_filename}.txt

termination() {
    kill $server_pid 2> /dev/null
    rm -f $data_file
    wait $server_pid
    echo run.sh: done. >&2
    exit ${1:-0}
}

trap termination 0
trap 'termination 1' INT TERM

_build.cowboy$version/default/bin/cowboy_post_bench ${opts} > $result_file &
server_pid=$!

base_url=http://localhost:$port

while ! curl -s -X GET $base_url/ > /dev/null 2>&1 ; do
    if !kill -0 $server_pid 2> /dev/null; then
        echo error: cannot start server >&2
        exit 1
    fi
    sleep 1
done

echo server pid: $server_pid >&2

echo genarate data file: $size bytes >&2
if ! dd bs=1 count=0 seek=$size of=$data_file 2> /dev/null; then
    echo error: dd failed >&2
    exit 1
fi

{
    for i in $(seq $times); do
        echo curl: $i >&3
        curl -v -s -S -X POST $base_url/cowboy$base_filename --data-binary @$data_file
    done
    echo curl: quit >&3
    curl -v -s -S -X POST $base_url/quit
} 3>&2 > $curl_log_file 2>&1

wait $server_pid

echo -n "cowboy$base_filename: average(ms)="
echo $(echo 'scale=3; (0'; < $result_file cut -f 2 | sed 's/^/+/'; echo ") / $times")  | bc
