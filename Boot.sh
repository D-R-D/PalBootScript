#!/bin/bash

## サーバのアップデートを行う
steamcmd +login anonymous +app_update 2394010 validate +quit


# 環境変数の値を取得
port_number=${PORT_NUMBER}
max_player=${MAX_PLAYER}
use_perf_threads=${USE_PERF_THREADS}
no_async_loading_thread=${NO_ASYNC_LOADING_THREAD}
user_multithread_for_ds=${USER_MULTITHREAD_FOR_DS}

# 引数の初期化
args=""

# PORT_NUMBERが設定されていれば、ポート番号が範囲内かチェックしてからport引数を追加
if [ -n "$port_number" ]; then
    if ! [[ "$port_number" =~ ^[0-9]+$ ]]; then
        echo "エラー: PORT_NUMBERは数字である必要があります。"
        exit 1
    fi

    if ((port_number < 0 || port_number > 65535)); then
        echo "エラー: PORT_NUMBERは0から65535の範囲である必要があります。"
        exit 1
    fi

    args="$args port=$port_number"
fi

# MAX_PLAYERが設定されていれば、players引数を追加
if [ -n "$max_player" ]; then
    if ! [[ "$max_player" =~ ^[0-9]+$ ]]; then
        echo "エラー: MAX_PLAYERは数字である必要があります。"
    fi

    if ((max_player < 1 || max_player > 32)); then
        echo "エラー: MAX_PLAYERは1から32の範囲である必要があります。"
    fi

    args="$args players=$max_player"
fi

if [ "$use_perf_threads" = "TRUE" ]; then
    args="$args -useperfthreads"
fi

if [ "$no_async_loading_thread" = "TRUE" ]; then
    args="$args -NoAsyncLoadingThread"
fi

if [ "$user_multithread_for_ds" = "TRUE" ]; then
    args="$args -UseMultithreadForDS"
fi

~/Steam/steamapps/common/PalServer/PalServer.sh $args