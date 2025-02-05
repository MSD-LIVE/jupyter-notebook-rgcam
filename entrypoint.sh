#!/bin/sh
set -e

# Run the basex server in the background.  Note only the DBPATH is overriden here, all 
# other settings are to replicate standard GCAM settings, we could experiment with these
# which may create trade off between DB write time / disk space / query time
# Any other settings will pull from the config file in ~/.basex
# IMPORTANT:  If you increase the container memory, you must also increase the
# -Xms and -Xmx JVM settings to utilize the additional memory
java -Xms6g -Xmx7g  -cp /basex/lib/*:/basex/BaseX.jar \
    -Dorg.basex.DBPATH=/basex/data \
    -Dorg.basex.ATTRINDEX=false \
    -Dorg.basex.FTINDEX=false \
    -Dorg.basex.UPDINDEX=false \
    -Dorg.basex.CHOP=true \
    -Dorg.basex.ADDCACHE=true \
    -Dorg.basex.INTPARSE=true \
    org.basex.BaseXHTTP -d &

cd /home/${NB_USER}
echo "Starting Jupyter Notebook..."
exec start.sh start-notebook.py