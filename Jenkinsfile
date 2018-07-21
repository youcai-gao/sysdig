pipeline {
    agent { dockerfile true }
    stages {
        stage('build') {
            steps {
                sh 'uname -a'
		sh 'ls -a /build'
		sh 'tree /build'
            }
        }
    }
}
