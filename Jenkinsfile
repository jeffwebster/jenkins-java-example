/* Requires the Docker Pipeline plugin */
// node {
//     echo "BRANCH_NAME: ${env.BRANCH_NAME}"
//     checkout scm
//     stage('Build') {
//         docker.image('maven:latest').inside {
//             sh 'mvn --version'
//         }
//     }
// }

/**
 * This pipeline describes a multi container job, running Maven and Nodejs builds
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
        echo "file from maven container - ${env.BUILD_TAG}" >> ./maven.txt
        pwd
        ls -lah
        """
      }
    }

    stage('Test Kaniko Container') {
      container('kaniko') {
        sh 'pwd'
        sh 'ls -lah'
        sh 'cat ./maven.txt'
      }
    }

  }
}
