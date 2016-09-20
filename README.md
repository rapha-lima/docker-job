# Docker-job

This is a restful service that launches a Docker-based job in an EC2 Spot Instance and automatically terminate it when the job is finished.

## How it works

The application exposes the following API endpoint:

#### GET /list

This endpoint will list all scheduled jobs.

e.g: `curl http://<app_host>/list`

#### GET /status/:id

This endpoint will list the status of a specific job.

The application show four status to each job, depends of the behavior for it:

* SCHEDULED
* RUNNING
* DONE
* FAILED
 
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

1 - The instance check each minute for the metadata to callback endpoint if it receive a termination-time.
 * e.g `curl -X PUT -d '{ "schedule": "" }' http://<app_host>/callback/<job_id`
 
2 - The instance callback call if the docker job not work as spectec.
* e.g `curl -X PUT -d '{ "failed": "", "error_message": "Some message" }' http://<app_host>/callback/<job_id`

3 - The instance callback call to mark job as done.
* e.g `curl -X PUT -d '{}' http://<app_host>/callback/<job_id`


## Technologies Used

* Ruby
* Sinatra
* Sidekiq
* Postgres
* AWS Ruby-SDK
* Docker-Compose

## How to deploy it

There is an script to deploy and run the app on AWS.

#### Steps:

* `git clone https://github.com/rapha-lima/docker-job.git ~/docker-job/`
* `cd ~/docker-job/script`
* `./deploy.sh`
 * You need to put here your AWS credentials. PS: It will launch the environment on us-east-1 region.

The `deploy.sh` script will provisoner a cloudformation stack with all elements needed to run and deploy the application.
The application will run in a docker container inside an ECS AWS linux based instance.

After deploy is done, you call schedule your docker jobs.

If you want to access the instance, has a private key `docker-job.pem` on script directory genereted by `deploy.sh` script.
