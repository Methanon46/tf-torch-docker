FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
LABEL version="0.1"
ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

# ubuntuリポジトリの日本localミラーサイトを参照してapt-getすると速い
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
# python3.12を使用するためにわざわざdeadsnakes/ppaを追加
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:deadsnakes/ppa \
 && apt-get purge -y software-properties-common \
 && apt-get update \
 && apt-get install -y \
    sudo\
    python3.10 \
 && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
 && apt-get install -y \
    python3.11-distutils \
    curl \
    git \
    lv \
    unzip \
    nano \
    inkscape \
    tzdata \
    wget \
    libgl1-mesa-dev \
    uff-converter-tf\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# tensorflow2ではgpuがあると、TensorRTのライブラリをチェックしてwarningを出すので、それ対策をいつかしたい

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

COPY requirements.txt ${PWD}
# pythonのパッケージをインストール
RUN pip3 install -U pip \
 && pip3 install torch==1.13.0+cu117 torchvision==0.14.0+cu117 torchaudio==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu117 \
 && pip3 install --timeout 100 -r requirements.txt

# matplotlibのfontsに日本語フォントを追加
RUN curl -L  "https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip" > font.zip
RUN unzip font.zip
RUN cp ./IPAexfont00401/ipaexg.ttf /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN chmod 744 /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN echo "font.family : IPAexGothic" >>  /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/matplotlibrc
RUN rm -rf ~/.cache/pip
