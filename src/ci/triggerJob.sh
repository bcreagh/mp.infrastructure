#!/usr/bin/env bash

jenkins_job=$1

user=$(cat ~/mpauth/jenkins_user)
token=$(cat ~/mpauth/jenkins_job)

curl -I -u ${user} "http://192.168.56.102:8080/job/${jenkins_job}/build?token=${token}"
