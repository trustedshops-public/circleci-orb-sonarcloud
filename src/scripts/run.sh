#!/bin/bash

export SONAR_TOKEN="${!PARAM_SONAR_TOKEN}"
export SCANNER_DIRECTORY=/tmp/cache/scanner
export SONAR_USER_HOME=$SCANNER_DIRECTORY/.sonar
export OS="linux"

if [[ ! -x "${SCANNER_DIRECTORY}/sonar-scanner-${PARAM_VERSION}-${OS}/bin/sonar-scanner" ]]; then
  curl -Ol "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${PARAM_VERSION}-${OS}.zip"
  unzip -qq -o "sonar-scanner-cli-${PARAM_VERSION}-${OS}.zip" -d ${SCANNER_DIRECTORY}
fi

chmod +x "${SCANNER_DIRECTORY}/sonar-scanner-${PARAM_VERSION}-${OS}/bin/sonar-scanner"
chmod +x "${SCANNER_DIRECTORY}/sonar-scanner-${PARAM_VERSION}-${OS}/jre/bin/java"

SCANNER_BIN="${SCANNER_DIRECTORY}/sonar-scanner-${PARAM_VERSION}-${OS}/bin/sonar-scanner"

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
${SCANNER_BIN} ${PR_ARGS}
