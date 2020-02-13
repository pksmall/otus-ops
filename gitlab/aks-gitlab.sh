#!/usr/bin/env bash

if command -v docker-machine > /dev/null 2>&1; then
  docker-machine=$(command -v docker-machine)
else
  echo docker-machine is not available. please will install it.
  exit
fi

