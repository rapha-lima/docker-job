# Docker-job

This is a restful service that launches a Docker-based job in an EC2 Spot Instance and automatically terminate it when the job is finished.

### How it works

The application exposes the following API endpoint:

#### GET /list

This endpoint will list all scheduled jobs.

e.g: `curl http://<app_host>/list`

#### GET /status/:id

This endpoint will list the status of a specific job.

The application show four status to each job, depends of the behavior for it:

######SCHEDULED

######RUNNING

######DONE

######FAILED
 
e.g `curl http://<app_host>/status/<job_id>`

#### POST /schedule

This endpoint will schedule the job that will launch and run the docker cointaner on a EC2 spot instance based.

This and point needs to pass some parameters on body call:

* docker_image  (string) required
* scheduled_for (String)(date-time) required
* env_vars      (json)(hash) not required

e.g: `curl -X POST -d '{ "docker_image": "<image>", "scheduled_for": "10:00", "env_vars": { "KEY": "VALUE" } http://<app_host>/schedule`

#### PUT /callback/:id

This endpoint is only to the instance provisioned call to perform a specific behavior.

1 - The instance check each minute for the metadata to handle an API call to callback endpoint if it receive a termination-time.
 * e.g `curl -X PUT -d '{ "schedule": "" }' http://<app_host>/callback/<job_id`
2 - The instance handle a callback call if the docker job not work as spectec.
3 - The instance handle a callback call to mark job as done.
