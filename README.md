# MSD-LIVE BLANK Notebook


This repo contains the Dockerfile to build the notebook image as well as the notebooks
used in the MSD-LIVE deployment. It will rebuild the image and redeploy the notebooks
whenever changes are pushed to the main branch.

**The data folder is too big, so we are not checking this into github. You will have
to pull from s3 if you want to test locally**

## Testing the notebook locally

1. Get the data

   ```bash
   # make sure you are in the jupyter-notebook-<<blank>> folder
   mkdir data
   cd data
   aws s3 cp s3://rgcam-notebook-bucket/data . --recursive

   ```

2. Start the notebook via docker compose
   ```bash
   # make sure you are in the jupyter-notebook-<<blank>> folder
   docker compose up
   ```

Notebook repos need to set these secrets (use *_uploader user to generate new access keys):  

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_S3_BUCKET



## Basex notes 
from a cell in a notebook this url to the database responded to wget: http://localhost:1984/rest
so we know it's running and accessible to the notebook. 

## currrent status
We don't yet have the Dockerfiles that installs gcam and configures basex so we can't
test the notebooks yet.

will need to change these lines in notebooks to point to localhost instead so remove these:
host <- gsub(':.*$', '', gsub('http://', '', Sys.getenv('JUPYTERHUB_API_URL')))

and just use as host 'locahost:1984'
