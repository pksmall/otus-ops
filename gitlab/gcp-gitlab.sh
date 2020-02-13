#!/usr/bin/env bash

if [ -z "$GCP_REGION" ]; then
	REGION="europe-west1-b"
else
	REGION=$GCP_REGION
fi

if command -v docker-machine > /dev/null 2>&1; then
  docker_machine=$(command -v docker-machine)
else
  echo "docker-machine is not available. please will install it."
  exit
fi

if [ -z "$MY_DOMAIN_NAME" ]; then
	echo "MY_DOMAIN_NAME is empty. please set it."
	echo "export MY_DOMAIN_NAME=example.com"
	exit
fi

if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
	echo "GOOGLE_APPLICATION_CREDENTIALS is empty. please set it."
	echo "export GOOGLE_APPLICATION_CREDENTIALS=your_credits_file.json"
	exit
fi

if [ -z "$GOGLE_PROJECT_ID" ]; then
	echo "GOGLE_PROJECT_ID is empty. please set it."
	echo "export GOGLE_PROJECT_ID=my-project-id"
	exit
fi

# run docker-machine and create gcp compute node
$docker_machine create --driver google --google-project=$GOGLE_PROJECT_ID \
 --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1804-lts \
 --google-machine-type n1-standard-1 \
 --google-open-port 80/tcp \
 --google-open-port 443/tcp \
 --google-open-port 2222/tcp \
 --google-open-port 2376/tcp \
 --google-zone $REGION \
 gitlab-host

# create docker-compose file
cat docker-compose.yml.tpl | sed -e "s/YOUHOSTNAME/${MY_DOMAIN_NAME}/g" | sed -e "s/YOUIP/${GITLAB_IP}/g" > docker-compose.yml

# run docker-compose in the remote docker host
eval $($docker_machine env gitlab-host)
docker-compose up -d

# exit from the remote host
eval $($docker_machine env --unset)

# get vpc ip
GITLAB_IP=$($docker_machine ip gitlab-host)
echo "Add this IP in your DNS as gitlab.your-domain-name"
echo $GITLAB_IP
