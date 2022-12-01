# pytorchの動作にはruntimeで十分だが、tensorflowの動作にはdevelが必要
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
LABEL version="0.1"
ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

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
    uff-converter-tf\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# tensorflow2ではgpuがあると、TensorRTのライブラリをチェックしてwarningを出すので、それ対策をいつかしたい

COPY requirements.txt ${PWD}
# pythonのパッケージをインストール
RUN pip3 install -U pip \
 && pip3 install --timeout 100 -r requirements.txt \
 && pip3 install git+https://github.com/tensorflow/docs \
 && pip3 install git+https://github.com/tensorflow/examples.git \
 && pip3 install git+https://www.github.com/keras-team/keras-contrib.git


# matplotlibのfontsに日本語フォントを追加
RUN curl -L  "https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip" > font.zip
RUN unzip font.zip
RUN cp ./IPAexfont00401/ipaexg.ttf /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN chmod 744 /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf
RUN echo "font.family : IPAexGothic" >>  /usr/local/lib/python3.8/dist-packages/matplotlib/mpl-data/matplotlibrc
RUN rm -rf ~/.cache/pip
