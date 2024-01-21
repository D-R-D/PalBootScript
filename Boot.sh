#!/bin/bash

## サーバー設定処理
setting_path="/root/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"
option_settings_line=$(grep 'OptionSettings=' "$file_path")

if [ "$oprion_settings_line" = "" ]; then
    echo "エラー: コンフィファイルが未生成です。"
    echo "./DefaultPalWorldSettings.iniの内容を./Pal/Saved/Config/LinuxServer/PalWorldSettings.iniにコピーしてください。"
else 
    # 各設定の正規表現パターン
    server_name_pattern='ServerName=.*'
    server_description_pattern='ServerDescription=.*'
    admin_password_pattern='AdminPassword=.*'
    server_password_pattern='ServerPassword=.*'
    defficulty_pattern='Difficulty=.*'
    guild_player_max_num_pattern='GuildPlayerMaxNum=.*'
    coop_player_max_num_pattern='CoopPlayerMaxNum=.*'
    is_multi_play_pattern='bIsMultiplay=.*'
    is_pvp_pattern='bIsPvP=.*'

    # 設定値をいい感じにする
    is_multi_play='False'
    if [ "$IS_MULTI_PLAY" = "TRUE" ]; then
        is_multi_play="True"
    fi
    is_pvp='False'
    if [ "$IS_PVP" = "TRUE" ]; then
        is_pvp='True'
    fi

    # 設定ファイルを書き換える
    new_option_settings_line=$(echo "$option_settings_line" | sed -E "s/$server_name_pattern/ServerName=$SERVER_NAME/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$server_description_pattern/ServerDescription=$SERVER_DESCRIPTION/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$admin_password_pattern/AdminPassword=$ADMIN_PASSWORD/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$server_password_pattern/ServerPassword=$SERVER_PASSWORD/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$defficulty_pattern/Difficulty=$DIFFICULTY/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$guild_player_max_num_pattern/GuildPlayerMaxNum=$GUILD_PLAYER_MAX_NUM/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$coop_player_max_num_pattern/CoopPlayerMaxNum=$COOP_PLAYER_MAX_NUM/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$is_multi_play_pattern/bIsMultiplay=$is_multi_play/")
    new_option_settings_line=$(echo "$new_option_settings_line" | sed -E "s/$is_pvp_pattern/bIsPvP=$is_pvp/")

    sed -i "s|${option_settings_line}|${new_option_settings_line}|" "$file_path"
fi

## サーバー起動処理
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
    fi

    if ((port_number < 0 || port_number > 65535)); then
        echo "エラー: PORT_NUMBERは0から65535の範囲である必要があります。"
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

/root/Steam/steamapps/common/PalServer/PalServer.sh $args