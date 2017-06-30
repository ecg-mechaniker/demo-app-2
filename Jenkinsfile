// properties([pipelineTriggers([cron('H/30 * * * *')])])
properties([pipelineTriggers([pollSCM('15 * * * *')])])


env.DOCKER_REPOSITORY = "registry.corp.mobile.de/techhack2017/9"

node('cloud') {
  stage('checkout') {
    checkout scm

    gitCommit = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
    date      = sh(script: "date +%Y%m%d%H%M%S", returnStdout: true).trim()
    branch    = sh(script: "echo '${env.BRANCH_NAME}' | sed  's/[^A-Za-z0-9]/_/g'", returnStdout: true).trim()

    currentBuild.displayName = "${branch}.${date}.${gitCommit}"

    // env.REVISION = "${BRANCH_NAME}-${BUILD_ID}-${gitCommit}".replaceAll("/", "-")
    env.LATEST = "${branch}.${date}.${gitCommit}.latest"
    env.PROD   = "${branch}.${date}.${gitCommit}.prod"
  }
  stage('docker build') {
    sh "docker build -t ${env.DOCKER_REPOSITORY}:${env.LATEST} ."
  }
  stage("docker push latest") {
    sh "docker push ${env.DOCKER_REPOSITORY}:${env.LATEST}"
  }
}

stage("docker push prod") {
  input "Push to PROD?"

  node('cloud') {
    sh "docker tag ${env.DOCKER_REPOSITORY}:${env.LATEST} ${env.DOCKER_REPOSITORY}:${env.PROD}"
    sh "docker push ${env.DOCKER_REPOSITORY}:${env.PROD}"
  }
}

echo "${env.DOCKER_REPOSITORY}:${env.LATEST}"
echo "${env.DOCKER_REPOSITORY}:${env.PROD}"
