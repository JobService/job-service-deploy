# Production Marathon Deployment

The Production Marathon deployment supports the deployment of the CAF Job Service on Mesos/Marathon. This folder contains the marathon environment and template files that are required to deploy the service application.

## Service Configuration

### Marathon Template
The `marathon.json.b` template file describes the marathon deployment information required for Job Service. The template file uses property substitution to get values for configurable properties **required** for service deployment. These properties are configured in the marathon environment file `marathon.env`.

### Marathon Environment
The `marathon.env` file supports configurable property settings necessary for service deployment. These include:

- `DOCKER_REGISTRY`: This setting configures the docker repository that the Job Service image will be pulled from. 

- `JOB_SERVICE_PORT`: This configures the port that the Job Service listens on. 

- `JOB_TRACKING_SERVICE_PORT`: This configures the port that the Job Tracking worker listens on

- `POSTGRES_DB_HOSTNAME`: This configures the host name for the Postgres database.

- `POSTGRES_DB_PORT`: This configures the port for the Postgres database.

- `POSTGRES_JOB_SERVICE_DB_USER`: The username for the Postgres database.

- `POSTGRES_JOB_SERVICE_DB_PASSWORD`: The password for the Postgres database.

- `CAF_RABBITMQ_HOST`: This configures the host for RabbitMQ.

- `CAF_RABBITMQ_PORT`: This configures the port for RabbitMQ.

- `CAF_RABBITMQ_USERNAME`: This configures the username for RabbitMQ.

- `CAF_RABBITMQ_PASSWORD`: This configures the password for RabbitMQ.


### Additional Marathon Configuration
The `marathon.json.b` deployment template file specifies default values for a number of additional settings which you may choose to modify directly for your custom deployment. These include:

##### Application CPU, Memory and Instances

- `cpus` : This setting can be used to configure the amount of CPU of each Job Service and Job Tracking container. This does not have to be a whole number. 
	- **Default Values:**
		- **Job Service: 0.5**
		- **Job Tracking: 0.1**


- `mem`: This configures the amount of RAM of each Job Service and Job Tracking container. Note that this property does not configure the amount of RAM available to the container but is instead an upper limit. If the container's RAM exceeds this value it will cause docker to destroy and restart the container. **Default Value: 1024**

- `instances`: This setting specifies the number of instances of the Job Service and Job Tracking containers to start on launch. **Default value: 1.**


## Service Deployment
In order to deploy the service application, issue the following command from the 'production-marathon' directory:

	source ./marathon.env ; \
	     cat marathon.json.b \
	     | perl -pe 's/\$\{(\w+)\}/(exists $ENV{$1}?$ENV{$1}:"NOT_SET_$1")/eg' \
	     | curl -H "Content-Type: application/json" -d @- http://localhost:8080/v2/groups/
