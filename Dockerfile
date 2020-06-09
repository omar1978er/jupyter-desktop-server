FROM jupyter/minimal-notebook:76402a27fd13

USER root

#Required to add repo
RUN apt-get update && apt-get install -y software-properties-common


RUN dpkg --add-architecture i386

#  Install BlueJ
RUN apt-get install -y openjdk-11-jdk && apt-get clean
RUN wget http://www.bluej.org/download/files/BlueJ-linux-422.deb && \
	dpkg -i BlueJ-linux-422.deb; apt-get install -f -y && \
	rm -f *.deb


USER ${NB_USER}

COPY setup.py setup.py
COPY MANIFEST.in MANIFEST.in
COPY jupyter_desktop/ jupyter_desktop/
COPY Desktop/ Desktop/
COPY environment.yml  environment.yml

USER root
RUN chmod +x Desktop/robotlab.sh
RUN chmod +x Desktop/neural.sh

USER ${NB_USER}
RUN conda env update --name base --file environment.yml
## conda info --envs
#RUN conda env update --name notebook --file environment.yml
#RUN conda activate myenv

RUN pip install jupyterlab_iframe
RUN jupyter labextension install jupyterlab_iframe
RUN jupyter serverextension enable --py jupyterlab_iframe
