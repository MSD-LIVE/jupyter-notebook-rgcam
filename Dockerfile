# FROM ghcr.io/msd-live/jupyter/r-notebook:dev
FROM ghcr.io/msd-live/jupyter/r-notebook:dev

# Install Java
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget openjdk-11-jre-headless unzip

# Install the full BaseX package
RUN cd / && \
    wget https://files.basex.org/releases/9.5.2/BaseX952.zip && \
    unzip BaseX952.zip && \
    rm BaseX952.zip

# We will need the "ModelInterface" from rgcam to be able to organize query results into tables
RUN cd / && \
    wget https://github.com/JGCRI/rgcam/archive/refs/tags/v1.2.0.zip && \
    unzip v1.2.0.zip && \
    mv rgcam-1.2.0/inst/ModelInterface/ModelInterface.jar /basex/lib/ && \
    rm -r v1.2.0.zip rgcam-1.2.0

# Change the /basex/data folder 

# make a data/basexdb folder and copy everything currently in s3's data folder into it.
# check into THIS repo that data folder
# in Dockerfile 
COPY data/basexdb/ /basex/data/

# RUN chmod 755 /basex/BaseX.jar
RUN chmod -R 777 /basex

# add in our custom jupyter config that starts the basex server

# Set the jupyter config file
# the /home/jovyan/.jupyter config location tells jupyter this is a user-specific config
# setting that could overwrite global settings
# COPY jupyter_server_config.py /home/jovyan/.jupyter/jupyter_server_config.py

# Add our custom .basex config file
COPY .basex /basex/.basex

# RUN pip install jupyter-server-proxy

# TODO implement copying of /data to user home dir instead of symlinking
# COPY msdlive_hooks /srv/jupyter/extensions/msdlive_hooks
# RUN pip install /srv/jupyter/extensions/msdlive_hooks

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
