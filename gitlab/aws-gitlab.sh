#!/usr/bin/env bash

if [ -z "$AWS_REGION" ]; then
	AWS_DEFAULT_REGION="eu-central-1"
else
	AWS_DEFAULT_REGION=$AWS_REGION
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

if [ -f "~/.aws/credentials" ]; then
    if [ -z "$AWS_ACCESS_KEY_ID" ]; then
        echo "AWS_ACCESS_KEY_ID is empty. please set it."
        echo "export AWS_ACCESS_KEY_ID=MY_ACCESS_KEY"
        echo "or use aws configure for config aws cli."
        exit
    fi

    if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "AWS_SECRET_ACCESS_KEY is empty. please set it."
        echo "export AWS_SECRET_ACCESS_KEY=MY_AWS_SECRET_ACCESS_KEY"
        echo "or use aws configure for config aws cli."
        exit
    fi
elis
   echo "Get aws keys from ~/.aws/credentials."
   AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep key_id | awk -F= '{print $2}')
   AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep secret_key | awk -F= '{print $2}')
    if [ -z "$AWS_ACCESS_KEY_ID" ]; then
        echo "AWS_ACCESS_KEY_ID is empty. please set it."
        echo "export AWS_ACCESS_KEY_ID=MY_ACCESS_KEY"
        echo "or use aws configure for config aws cli."
        exit
    fi

    if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "AWS_SECRET_ACCESS_KEY is empty. please set it."
        echo "export AWS_SECRET_ACCESS_KEY=MY_AWS_SECRET_ACCESS_KEY"
        echo "or use aws configure for config aws cli."
        exit
    fi

fi

# run docker-machine and create gcp compute node
$docker_machine create --driver amazonec2 \
 --amazonec2-access-key $AWS_ACCESS_KEY_ID \
 --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY \
 --amazonec2-ami ami-1c45e273 \
 --amazonec2-instance-type t2.large \
 --amazonec2-open-port 80 \
 --amazonec2-open-port 443 \
 --amazonec2-open-port 2222 \
 --amazonec2-open-port 2376 \
 --amazonec2-open-port 5050 \
 --amazonec2-root-size 40 \
 --amazonec2-region $AWS_DEFAULT_REGION \
 gitlab-host

# get vpc ip
GITLAB_IP=$($docker_machine ip gitlab-host)
echo "Add this IP in your DNS as gitlab.your-domain-name"
echo $GITLAB_IP

if [ ! -z "$GITLAB_IP" ]; then
    # create docker-compose file
    cat docker-compose.yml.tpl | sed -e "s/YOUHOSTNAME/${MY_DOMAIN_NAME}/g" | sed -e "s/YOUIP/${GITLAB_IP}/g" > docker-compose.yml

    # run docker-compose in the remote docker host
    eval $($docker_machine env gitlab-host)
    docker-compose up -d

    # exit from the remote host
    eval $($docker_machine env --unset)
fi
