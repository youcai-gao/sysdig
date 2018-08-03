pipeline {
    agent { label 'probe-builder-test' }
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
                    "test_parallel" 	: { sh 'sleep 60 && echo test_parallel' },
                    "fedora-atomic" 	: { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable Fedora-Atomic' },
                    "ubuntu" 		    : { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable Ubuntu' },
                    //"debian" 		: { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable Debian' },
                    "rhel"   		    : { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable RHEL' },
                    "fedora" 	        : { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable Fedora' },
                    //"coreos" 		: { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable CoreOS' },
                    //"boot2docker" 	: { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable boot2docker' },
                    "oracle_rhck" 	    : { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable Oracle_RHCK' },
                    "oracle_linux6_uek" : { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable Oracle_Linux_6_UEK' },
                    "oracle_linux7_uek" : { sh 'cd probe && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe 0.22.0 stable Oracle_Linux_7_UEK' },
                    "amazon_linux" 	    : { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable AmazonLinux' },
                    "amazon_linux2" 	: { sh 'cd probe && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe 0.22.0 stable AmazonLinux2' },
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
