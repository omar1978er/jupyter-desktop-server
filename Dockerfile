FROM jupyter/minimal-notebook:76402a27fd13

USER root

#Required to add repo
RUN apt-get update && apt-get install -y software-properties-common

# Maybe better - for the apt.packages:
COPY apt.txt apt.txt 
RUN xargs apt-get install -y < apt.txt \
    && apt-get clean


RUN dpkg --add-architecture i386

#  Install BlueJ
RUN apt-get install -y openjdk-11-jdk openjfx && apt-get clean
RUN wget http://www.bluej.org/download/files/BlueJ-linux-422.deb && \
	dpkg -i BlueJ-linux-422.deb; apt-get install -f -y && \
	rm -f *.deb


# Install IJava
# via https://github.com/ntartania/INF1563_Notebooks/blob/master/Dockerfile
# Download the kernel release
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip

# Unpack and install the kernel
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix


USER ${NB_USER}

COPY setup.py setup.py
COPY MANIFEST.in MANIFEST.in
COPY jupyter_desktop/ jupyter_desktop/
COPY environment.yml  environment.yml

COPY Desktop/ Desktop/

USER ${NB_USER}
RUN conda env update --name base --file environment.yml
## conda info --envs
#RUN conda env update --name notebook --file environment.yml
#RUN conda activate myenv

RUN pip install jupyterlab_iframe
RUN jupyter labextension install jupyterlab_iframe
RUN jupyter serverextension enable --py jupyterlab_iframe
