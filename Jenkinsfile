pipeline {
    agent { dockerfile true }
    stages {
        stage('build') {
            steps {
                sh 'uname -a'
		checkout scm
		sh 'pwd'
		sh 'mkdir -p xxx && cd xxx && bash -x ../scripts/build-probe-binaries sysdig-probe 0.22.0 test Fedora-Atomic' 
		sh 'pwd'
		sh 'ls -l xxx'
            }
        }
    }
}
