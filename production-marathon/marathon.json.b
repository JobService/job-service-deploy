{
	"id": "/caf/jobservice",
	"apps": [{

			"id": "job-service",
			"cpus": 0.5,
			"mem": 1024,
			"instances": 1,
			"container": {
				"docker": {
					"image": "${docker_registry}/jobservice/job-service",
					"network": "BRIDGE",
					"portMappings": [{
						"containerPort": 8080,
						"hostPort": 0,
						"protocol": "tcp",
						"servicePort": 9220
					}],
					"forcePullImage": ${force_pull}
				},
				"type": "DOCKER"
			},
			"healthChecks": [{
				"protocol": "HTTP",
				"gracePeriodSeconds": 300,
				"intervalSeconds": 120,
				"maxConsecutiveFailures": 5,
				"path": "/",
				"timeoutSeconds": 20
			}],
			"env": {
				"_JAVA_OPTIONS": "-Xms512m -Xmx512m",
				"CAF_CONFIG_PATH": "/mnt/mesos/sandbox",
				"CAF_DATABASE_URL": "jdbc:postgresql://${postgres_db_hostname}:${postgres_db_port}/jobservicedb?characterEncoding=UTF8&rewriteBatchedStatements=true",
				"CAF_DATABASE_USERNAME": "${postgres_job_service_db_user}",
				"CAF_DATABASE_PASSWORD": "${postgres_job_service_db_password}",
				"CAF_TRACKING_PIPE": "${jobtracking_inputqueue}",
				"CAF_STATUS_CHECK_TIME": "${job_service_status_check_time}",
				"CAF_WEBSERVICE_URL": "http://${internal_proxy_host}:26080/job-service/v1",
				"CAF_RABBITMQ_HOST": "${rabbit_host}",
				"CAF_RABBITMQ_PORT": "${rabbit_port}",
				"CAF_RABBITMQ_USERNAME": "${rabbit_user}",
				"CAF_RABBITMQ_PASSWORD": "${rabbit_password}"
			}
		},
		{
			"id": "jobtracking",
			"cpus": 0.1,
			"mem": 1024,
			"instances": 1,
			"container": {
				"type": "DOCKER",
				"docker": {
					"image": "${docker_registry}/jobservice/worker-jobtracking",
					"network": "BRIDGE",
					"forcePullImage": ${force_pull},
					"portMappings": [{
							"containerPort": 8080,
							"hostPort": 0,
							"protocol": "tcp",
							"servicePort": 9330
						},
						{
							"containerPort": 8081,
							"hostPort": 0,
							"protocol": "tcp",
							"servicePort": 9331
						}
					]
				}
			},
			"env": {
				"_JAVA_OPTIONS": "-Xms512m -Xmx512m",
				"CAF_CONFIG_PATH": "/mnt/mesos/sandbox",
				"JOB_DATABASE_URL": "jdbc:postgresql://${postgres_db_hostname}:${postgres_db_port}/jobservicedb?characterEncoding=UTF8&rewriteBatchedStatements=true",
				"JOB_DATABASE_USERNAME": "${postgres_job_service_db_user}",
				"JOB_DATABASE_PASSWORD": "${postgres_job_service_db_password}"
			},
			"healthChecks": [{
				"path": "/healthcheck",
				"protocol": "HTTP",
				"portIndex": 1,
				"gracePeriodSeconds": 300,
				"intervalSeconds": 120,
				"maxConsecutiveFailures": 5,
				"timeoutSeconds": 20
			}],
			"labels": {
				"autoscale.maxinstances": "4",
				"autoscale.metric": "rabbitmq",
				"autoscale.mininstances": "1",
				"autoscale.scalingprofile": "default",
				"autoscale.scalingtarget": "1",
				"autoscale.interval": "30",
				"autoscale.backoff": "10"
			}
		}

	]
}