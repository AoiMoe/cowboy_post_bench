#! /bin/sh

version=$1
size=$2
times=$3

if test -z "$version" -o -z "$size" -o -z "$times"; then
    echo "usage: $0 <version> <size> <times>" >&2
    exit 1
fi

echo running for cowboy-$version, size=$size, $times{times} >&2
resultdir=${RESULTDIR:-result}
data_file=$resultdir/tmp-$version-$size-$times.dat
result_file=$resultdir/result-$version-$size-$times.tsv
curl_log_file=$resultdir/curl-log-$version-$size-$times.txt
port=11111

termination() {
    kill $server_pid 2> /dev/null
    rm -f $data_file
    wait $server_pid
    echo run.sh: done. >&2
    exit ${1:-0}
}

trap termination 0
trap 'termination 1' INT TERM

_build.cowboy$version/default/bin/cowboy_post_bench -p $port > $result_file &
server_pid=$!

base_url=http://localhost:$port

while ! curl -s -X GET $base_url/ > /dev/null 2>&1 ; do
    sleep 1
done

echo server pid: $server_pid >&2

echo genarate data file: $size bytes >&2
dd bs=1 count=0 seek=$size of=$data_file 2> /dev/null

{
    for i in $(seq $times); do
        echo curl: $i >&3
        curl -v -s -S -X POST $base_url/cowboy$version-$size --data-binary @$data_file
    done
    echo curl: quit >&3
    curl -v -s -S -X POST $base_url/quit
} 3>&2 > $curl_log_file 2>&1

wait $server_pid

echo -n "cowboy-$version, size=$size, ${times}times average(ms): "
echo $(echo 'scale=3; (0'; < $result_file cut -f 2 | sed 's/^/+/'; echo ") / $times")  | bc
