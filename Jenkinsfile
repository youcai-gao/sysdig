pipeline {
    agent { dockerfile true }
    stages {
        stage('build') {
            steps {
                sh 'uname -a'
		checkout scm
		sh 'pwd'
		sh 'mkdir xxx && cd xxx && ../scripts/build-probe-binaries 0.22.0 test CONTAINER-Fedora-Atomic' 
		sh 'pwd'
		sh 'ls -l xxx'
            }
        }
    }
}
