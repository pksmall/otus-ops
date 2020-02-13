web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.YOUHOSTNAME'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
     external_url 'http://YOUIP'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
    - '5050:5050'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
