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

# Maybe better - for the apt.packages:
#COPY apt.txt apt.txt 
#RUN xargs sudo apt-get install < pkglist

USER ${NB_USER}

COPY setup.py setup.py
COPY MANIFEST.in MANIFEST.in
COPY jupyter_desktop/ jupyter_desktop/
COPY Desktop/ Desktop/
COPY Apps/ Apps/
COPY environment.yml  environment.yml

USER root
RUN chmod +x Desktop/robotlab.sh
RUN chmod +x Desktop/neural.sh

USER ${NB_USER}
RUN conda env update --name base --file environment.yml
## conda info --envs
#RUN conda env update --name notebook --file environment.yml
#RUN conda activate myenv
