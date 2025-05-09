FROM ghcr.io/msd-live/jupyter/r-notebook:latest

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

RUN chmod -R 777 /basex

# Add our custom .basex config file
COPY .basex /basex/.basex

RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"
RUN R -e "remotes::install_github('JGCRI/rgcam', build_vignettes=TRUE)"
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org')"
RUN conda install -c conda-forge imagemagick
RUN R -e "install.packages('magick', repos='https://cloud.r-project.org', lib = .libPaths()[1])"
RUN R -e "remotes::install_github('JGCRI/jgcricolors', dependencies=TRUE)"
RUN R -e "remotes::install_github('JGCRI/rchart', dependencies=TRUE)"
RUN conda install udunits libgdal gdal geos proj
RUN conda install r-terra r-sf
RUN apt-get update && apt-get install -y g++
RUN R -e "remotes::install_github('JGCRI/rmap', dependencies=TRUE)"

# copy the notebooks to the container
COPY notebooks /home/jovyan/notebooks

# install the msdlive plugin in order for the msdlive labs extension to discover it via entry points and 
# copy the files to /basex/data dir
COPY msdlive_hooks /srv/jupyter/extensions/msdlive_hooks
RUN pip install /srv/jupyter/extensions/msdlive_hooks

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]