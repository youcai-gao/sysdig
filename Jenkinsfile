pipeline {
    agent { label 'sysdig-probe-builder' }
    stages {
        stage ('preparation') {
            steps {
                sh 'hostname'
                sh 'uname -a'
                sh 'pwd -P'
                sh 'df -h'
		dir('sysdig') { checkout scm }
                sh 'pwd -P; df -h'
                sh 'ls -l'
                sh 'echo build dokcer images of various builders ...'
                sh 'sysdig/scripts/build-builder-containers.sh'
                sh 'docker images'
                sh 'docker ps'
                sh 'mkdir -p probe'
            }
        }

        stage ('compilation') {
            steps {
                parallel (
                    "info" : { sh 'pwd -P && df -h' },
                    "foo" : { sh 'sleep 60 && echo foo' },
                    "bar" : { sh 'sleep 60 && echo bar' },
                //    "fedora-atomic" : { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable Fedora-Atomic' },
                //    "ubuntu" : { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable Ubuntu' },
                )
            }
        }
    
        stage ('s3 publishing') {
	    when { branch "jenkins-pipeline-test" }
            steps {
                sh 'hostname'
                sh 'uname -a'
                sh 'pwd -P'
		sh 'echo workspace = $WORKSPACE'
                sh 'df -h'
                sh 'ls -l probe/output/'
		build job: "test-publish-probe-modules", propagate: false, wait: false, parameters: [ string(name: 'WDIR', value: "${WORKSPACE}") ]
		sh ' echo probe modules published'
            }
        }
    }
}
