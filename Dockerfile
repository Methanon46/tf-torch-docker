
FROM nvidia/cuda:11.7.1-runtime-ubuntu20.04
LABEL version="0.1"
ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# ubuntuリポジトリの日本localミラーサイトを参照してapt-getすると速い
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    sudo\
    python3-pip \
    curl \
    git \
    lv \
    unzip \
    nano \
    inkscape \
    tzdata \
    wget \
    libgl1-mesa-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ${PWD}
# pythonのパッケージをインストール
RUN pip3 install -U pip
RUN pip3 install --timeout 100 -r requirements.txt
RUN pip3 install git+https://github.com/tensorflow/docs
RUN pip3 install git+https://github.com/tensorflow/examples.git
RUN pip3 install git+https://www.github.com/keras-team/keras-contrib.git

# matplotlibのfontsに日本語フォントを追加
RUN curl -L  "https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip" > font.zip
RUN unzip font.zip
RUN cp ./IPAexfont00401/ipaexg.ttf /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN chmod 744 /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN echo "font.family : IPAexGothic" >>  /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/matplotlibrc
RUN rm -rf ~/.cache/pip

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