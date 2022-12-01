FROM tf-torch:latest
# docker-compose.ymlで設定した環境変数を導入
ARG UID
ARG GID
ARG USERNAME
# グループ・ユーザーを追加
RUN groupadd -g ${GID} ${USERNAME} \
  && useradd -u ${UID} -g ${GID} -s /bin/bash -m ${USERNAME} \
  && usermod -G sudo ${USERNAME}

# コンテナを操作するユーザーをルートから一般ユーザーに変更(必ず最終行で設定する)
USER ${UID}
