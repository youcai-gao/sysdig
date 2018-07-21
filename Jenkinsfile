pipeline {
    agent { dockerfile true }
    stages {
        stage('build') {
            steps {
                sh 'uname -a'
		checkout scm
		sh 'ls -a ' 
		sh 'tree /build'
            }
        }
    }
}
