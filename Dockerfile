# syntax=docker/dockerfile:1.4

## 設定
FROM steamcmd/steamcmd:latest
ENV TZ=Asia/Tokyo
# 起動変数用の環境変数
ENV PORT_NUMBER=8211
ENV MAX_PLAYER=32
ENV USE_PERF_THREADS=FALSE
ENV NO_ASYNC_LOADING_THREAD=FALSE
ENV USER_MULTITHREAD_FOR_DS=FALSE
# ゲーム設定用の環境変数
ENV SERVER_NAME="Pal World Server Contianer"
ENV SERVER_DESCRIPTION="Running by docker"
ENV ADMIN_PASSWORD=""
ENV SERVER_PASSWORD=""
ENV DIFFICULTY=None
ENV GUILD_PLAYER_MAX_NUM=20
ENV COOP_PLAYER_MAX_NUM=4
ENV IS_MULTI_PLAY=TRUE
ENV IS_PVP=FALSE
# アップデートとユーザー作成
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils \
    && apt-get install -y wget \
    && useradd -m -s /bin/bash paluser \
    && chmod -R 755 /root \
    && chown -R paluser /root

USER paluser
WORKDIR /home/paluser

## PalWorldのサーバーセットアップ
# エラー対策
RUN mkdir -p ~/.steam/sdk64/ \
    && steamcmd +login anonymous +app_update 1007 +quit \
    && cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ~/.steam/sdk64/
# ブートスクリプトのダウンロード
RUN wget https://raw.githubusercontent.com/D-R-D/PalBootScript/main/Boot.sh \
    && chmod +x Boot.sh
# サーバー更新用スクリプトentrypoint.shを作成
RUN echo '#!/bin/bash' > entrypoint.sh \
    && echo 'steamcmd +login anonymous +app_update 2394010 validate +quit' >> entrypoint.sh \
    && echo 'exec "$@"' >> entrypoint.sh \
    && chmod +x entrypoint.sh

## サーバーをアップデートして起動
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./Boot.sh"]