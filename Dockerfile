FROM nvcr.io/nvidia/tensorflow:18.08-py3
LABEL maintainer='Sukesan1984'
EXPOSE 8889
WORKDIR /notebooks

RUN apt-get update \
  && apt-get install -y --no-install-recommends m4 autoconf automake libtool flex \
  && apt-get install -y --no-install-recommends libnccl2 libnccl-dev \
  && apt-get install -y --no-install-recommends ssh \
  && apt-get clean

# pip install
COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# depend on jupyter  so after pip install.
RUN jupyter contrib nbextension install --user
WORKDIR /root/.local/share/jupyter/nbextensions
RUN git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
RUN jupyter nbextension enable vim_binding/vim_binding
RUN jupyter nbextension enable codefolding/main

# adhoc apt
RUN apt update && apt install -y libsm6 libxext6
RUN apt-get install -y libxrender-dev
RUN apt-get install -y fonts-ipaexfont
COPY matplotlibrc /usr/local/lib/pytho3.5/dist-packages/matplotlib/mpl-data/matplotlibrc
COPY ipaexg.ttf /usr/local/lib/python3.5/dist-packages/matplotlib/mpl-data/fonts/ttf

WORKDIR /notebooks
RUN pip install tensorflow

RUN apt update && apt install -y graphviz
RUN pip install pydot graphviz
