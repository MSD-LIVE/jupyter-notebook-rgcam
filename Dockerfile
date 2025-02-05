# FROM ghcr.io/msd-live/jupyter/r-notebook:dev
FROM ghcr.io/msd-live/jupyter/python-notebook:dev

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

# Change the /basex/data folder to be symlinked to /bucket/data 
# RUN rmdir /basex/data && ln -s /data /basex/data
RUN rmdir /basex/data 
COPY basexdb /basex/data

# RUN chmod 755 /basex/BaseX.jar
RUN chmod -R 777 /basex

# add in our custom jupyter config that starts the basex server

# Set the jupyter config file
# the /home/jovyan/.jupyter config location tells jupyter this is a user-specific config
# setting that could overwrite global settings
COPY jupyter_server_config.py /home/jovyan/.jupyter/jupyter_server_config.py

# Add our custom .basex config file
COPY .basex /basex/.basex

RUN pip install jupyter-server-proxy

# we don't yet know if this will be necessary, basex might start up quickly enough (it sure fails quickly)
# install the msdlive plugin in order for the msdlive labs extension to discover it via entry points and 
# start up the basex server as soon as the notebook loads instead of waiting for basex to start
# COPY msdlive_hooks /srv/jupyter/extensions/msdlive_hooks
# RUN pip install /srv/jupyter/extensions/msdlive_hooks

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
