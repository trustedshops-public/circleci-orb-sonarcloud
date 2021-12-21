#!/bin/bash

export SONAR_TOKEN="${!PARAM_SONAR_TOKEN}"

# Report quality status on pull requests
if [[ -n $CIRCLE_PULL_REQUEST ]];
then
  PR_ARGS="-Dsonar.pullrequest.key=${CIRCLE_PULL_REQUEST##*/} \
           -Dsonar.pullrequest.base=${PARAM_DEFAULT_BRANCH} \
           -Dsonar.pullrequest.provider=${PARAM_PR_PROVIDER} \
           -Dsonar.pullrequest.branch=${CIRCLE_BRANCH} \
           -Dsonar.pullrequest.github.repository=${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"
fi

# shellcheck disable=SC2086
mvn ${PR_ARGS} \
  -Dsonar.login="${SONAR_TOKEN}" \
  sonar:sonar
