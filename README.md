# Docker-job

This is a restful service that launches a Docker-based job in an EC2 Spot Instance and automatically terminate it when the job is finished.

### How it works

The application exposes the following API endpoint:

##### GET /list

This endpoint will list all scheduled jobs.

e.g: `curl http://<endpoint>/list`

##### GET /status/:id

This endpoint will list the status of a specific job.

The application show four status to each job, depends of the behavior for it:
 #SCHEDULED
 #RUNNING
 #DONE
 #FAILED
 
e.g `curl http://<endpoint>/status/<job_id>

##### POST /schedule

##### PUT /callback/:id
