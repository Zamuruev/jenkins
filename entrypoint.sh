#!/bin/bash

java -jar /usr/share/jenkins/agent.jar -secret "$JENKINS_SECRET" -name "$JENKINS_AGENT_NAME" -url "$JENKINS_URL" &

java -jar /app.jar