/**
 * This pipeline describes a multi container job, running Maven and Kaniko
 */

podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
  - name: regcred
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
        sh "mvn test"
       }
    }

    stage('Package') {
      container('maven') {
        sh "mvn clean package"
      }
    }

    stage('Test Kaniko Container') {
      container('kaniko') {
        sh """
        echo "Hello from kaniko container"
        pwd
        ls -lah
        """
      }
    }

    withEnv([
      'DOCKERFILE=Dockerfile',
      'BUILD_JAR_NAME=target/spring-boot-0.0.1-SNAPSHOT.jar'
    ]) {
      stage('Build Image') {
        container('kaniko') {
          sh "/kaniko/executor --dockerfile=${env.DOCKERFILE} --build-arg build_jar_name=${env.BUILD_JAR_NAME}  --no-push"
          sh 'ls -lah'
        }
      }
    }

  } // node(POD_LABEL) {
}
