# Production Docker Swarm Deployment

The Production Docker Stack Deployment supports the deployment of the CAF Job Service on Docker Swarm. This folder contains the `docker-stack.yml` file and an environment file for the Docker Stack deployment in addition to an environment file for RabbitMQ.

## Service Configuration

### Docker Stack
The `docker-stack.yml` file describes the Docker deployment information required for the CAF Job Service. The file uses property substitution to retrieve values from Environment variables. A number of these Environment variables are **required** for the Job Service deployment. These Environment variable are configurable in the Docker environment file.

### Docker Environment
The `docker-stack.env` file supports configurable property settings necessary for service deployment. These include:  

**Required**  
* `POSTGRES_DB_HOSTNAME` : Hostname of the Postgres DB Server  

**Smart Defaults**  
* `POSTGRES_DB_PORT` : Port number of the Postgres DB Server. Will default to "5432"  
* `CAF_DATABASE_USERNAME` : Username of the Postgres DB Server. Will default to "postgres"  
* `CAF_DATABASE_PASSWORD` : Password of the Postgres DB Server. Will default to "root"  
* `CAF_TRACKING_PIPE_IN` : Job Service Tracking Pipe In. Will default to "jobtracking-in"  
* `CAF_TRACKING_PIPE_OUT` : Job Service Tracking Pipe Out. Will default to "jobtracking-out"  
* `JOB_SERVICE_PORT` : Job Service Port. Will default to "9411"  

### Additional Docker Configuration
The `docker-stack.yml` file specifies default values for a number of additional settings which you may choose to modify directly for your custom deployment. These include:  

#### Deploy

##### Restart Policy
* `condition` : One of none, on-failure or any (default: any)
* `delay` : How long to wait between restart attempts, specified as a duration (default: 0)
* `max_attempts` : How many times to attempt to restart a container before giving up (default: never give up)
* `window` : How long to wait before deciding if a restart has succeeded, specified as a duration (default: decide immediately)

##### Replicas
* `mode` : Either global (exactly one container per swarm node) or replicated (a specified number of containers) (default replicated)
* `replicas` : If the service is replicated (which is the default), specify the number of containers that should be running at any given time

##### Resources > Limits
* `cpus`: This setting can be used to configure the amount of CPU of each CAF Audit Web Service container. This does not have to be a whole number
* `memory`: This configures the amount of RAM of each Job Service container. Note that this property does not configure the amount of RAM available to the container but is instead an upper limit. If the container's RAM exceeds this value it will cause docker to destroy and restart the container

##### Update Config
* `parallelism` : The number of containers to update at a time
* `delay` : The time to wait between updating a group of containers

## Execution

To deploy the stack:  
* Edit `rabbit.env`  
* Edit `docker-stack.env`  
* `source docker-stack.env`  
* `docker stack deploy --compose-file=docker-stack.yml jobServiceProd`  

To tear down the stack:  
* `docker stack rm jobServiceProd`