FROM jupyter/minimal-notebook:76402a27fd13

USER root

#Required to add repo
RUN apt-get update && apt-get install -y software-properties-common


RUN dpkg --add-architecture i386

ENV WINEDLLOVERRIDES="mscoree,mshtml="

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
RUN apt update && apt-get install -y --install-recommends winehq-stable \
    && apt-get install -y dbus-x11 firefox xfce4 xfce4-panel xfce4-session xfce4-settings xorg xubuntu-icon-theme \
    && apt-get clean


USER ${NB_USER}

COPY setup.py setup.py
COPY MANIFEST.in MANIFEST.in
COPY jupyter_desktop/ jupyter_desktop/
COPY Desktop/ Desktop/
COPY Apps/ Apps/
COPY environment.yml  environment.yml

RUN chmod +x Desktop/robotlab.sh
RUN chmod +x Desktop/neural.sh


RUN conda env update --file environment.yml
