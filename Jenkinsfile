/**
 * This pipeline describes a multi container job, running Maven and Kaniko
 */

podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
  - name: regcred
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: .dockerconfigjson
              path: config.json
  containers:
  - name: maven
    image: jwebster2/my-repo:jenkins-builder-maven-0.1.0
    command: ["sleep"]
    args: ["3650d"]
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    entrypoint: [""]
    command: ["sleep"]
    args: ["3650d"]
    volumeMounts:
    - name: jenkins-docker-cfg
      mountPath: /kaniko/.docker
"""
  ) {

  node(POD_LABEL) {

    echo "BRANCH_NAME: ${env.BRANCH_NAME}"
    checkout scm

    stage('Test Maven Container') {
      container('maven') {
        sh """
        echo "Hello from maven container"
        mvn -version
        pwd
        ls -lah
        env|sort
        """
      }
    }

    stage('Unit Test') {
      container('maven') {
        sh "mvn test --quiet"
       }
    }

    stage('Package') {
      container('maven') {
        sh "mvn clean package --quiet"
      }
    }

    stage('Test Kaniko Container') {
      container('kaniko') {
        sh """
        echo "Hello from kaniko container"
        pwd
        ls -lah
        ls -lah target
        ls -lah  ../
        ls -la /kaniko
        ls -la /
        cat /kaniko/.docker/config.json
        """
      }
    }

    withEnv([
      "DOCKERFILE=Dockerfile",
      "BUILD_JAR_NAME=spring-boot-0.0.1-SNAPSHOT.jar",
      "DESTINATION=jwebster2/my-repo",
      "TAG_NAME=gs-spring-boot"
    ]) {
      stage('Build Image') {
        container('kaniko') {
          sh "/kaniko/executor --skip-tls-verify --context=${env.WORKSPACE} --dockerfile=${env.DOCKERFILE} --build-arg build_jar_name=${env.BUILD_JAR_NAME}  --destination=${env.DESTINATION}:${env.TAG_NAME}"
        }
      }
    }

  } // node(POD_LABEL) {
}
