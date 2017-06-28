// properties([pipelineTriggers([cron('H/30 * * * *')])])
properties([pipelineTriggers([pollSCM('* * * * *')])])


env.DOCKER_REPOSITORY = "registry.corp.mobile.de/techhack2017/demo-app-2"

node('cloud') {
  stage('checkout') {
    checkout scm

    gitCommit = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
    date      = sh(script: "date +%Y%m%d%H%M%S", returnStdout: true).trim()
    branch    = sh(script: "echo '${env.BRANCH_NAME}' | sed  's/[^A-Za-z0-9]/_/g'", returnStdout: true).trim()

    // env.REVISION = "${BRANCH_NAME}-${BUILD_ID}-${gitCommit}".replaceAll("/", "-")
    env.LATEST = "${branch}.${date}.${gitCommit}.latest"
    env.QA     = "${branch}.${date}.${gitCommit}.qa"
    env.PROD   = "${branch}.${date}.${gitCommit}.prod"
  }
  stage('docker build') {
    sh "docker build -t ${env.DOCKER_REPOSITORY}:${env.LATEST} ."
  }
  stage("docker push latest") {
    sh "docker push ${env.DOCKER_REPOSITORY}:${env.LATEST}"
  }
}

stage("docker push qa") {
  input "Push to QA?"

  node('cloud') {
    sh "docker tag ${env.DOCKER_REPOSITORY}:${env.LATEST} ${env.DOCKER_REPOSITORY}:${env.QA}"
    sh "docker push ${env.DOCKER_REPOSITORY}:${env.QA}"
  }
}

stage("docker push prod") {
  input "Push to PROD?"

  node('cloud') {
    sh "docker tag ${env.DOCKER_REPOSITORY}:${env.LATEST} ${env.DOCKER_REPOSITORY}:${env.PROD}"
    sh "docker push ${env.DOCKER_REPOSITORY}:${env.PROD}"
  }
}
