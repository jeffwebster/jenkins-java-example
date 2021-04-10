/* Requires the Docker Pipeline plugin */
node {
    echo "BRANCH_NAME: ${env.BRANCH_NAME}"
    checkout scm
    stage('Build') {
        docker.image('maven:3.3.3').inside {
            sh 'mvn --version'
        }
    }
}
