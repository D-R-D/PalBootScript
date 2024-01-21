# syntax=docker/dockerfile:1.4

## 設定
FROM steamcmd/steamcmd:latest
ENV TZ=Asia/Tokyo
# プロパティ用の環境変数設定
ENV PORT_NUMBER=8211
ENV MAX_PLAYER=32
ENV USE_PERF_THREADS=FALSE
ENV NO_ASYNC_LOADING_THREAD=FALSE
ENV USER_MULTITHREAD_FOR_DS=FALSE
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
# 更新兼ブートスクリプトのダウンロード
RUN wget https://raw.githubusercontent.com/D-R-D/PalBootScript/main/Boot.sh

CMD ["/bin/bash", "~/Boot.sh"]
