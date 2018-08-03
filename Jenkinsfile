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
                    "fedora-atomic" 	: { sh 'mkdir -p probe/fedora_atomic && cd probe/fedora_atomic && docker run -i --rm --name fedora-atomic-build -v ${PWD}:/build/probe fedora-builder sysdig-probe jenkins-pipeline-test stable Fedora-Atomic && cp -u output/* ../output/ '},
                    "ubuntu" 		    : { sh 'mkdir -p probe/ubuntu        && cd probe/ubuntu        && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable Ubuntu && cp -u output/* ../output/ '},
                    "debian" 		    : { sh 'mkdir -p probe/debian        && cd probe/debian        && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable Debian && cp -u output/* ../output/ ' },
                    "rhel"   		    : { sh 'mkdir -p probe/rhel          && cd probe/rhel          && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable RHEL && cp -u output/* ../output/ ' },
                    "fedora" 	        : { sh 'mkdir -p probe/fedora        && cd probe/fedora        && docker run -i --rm --name fedora-build -v ${PWD}:/build/probe fedora-builder sysdig-probe jenkins-pipeline-test stable Fedora && cp -u output/* ../output/ ' },
             //       "coreos" 		    : { sh 'mkdir -p probe/coreos        && cd probe/coreos        && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable CoreOS && cp -u output/* ../output/ ' },
                    "boot2docker" 	    : { sh 'mkdir -p probe/boot2docker   && cd probe/boot2docker   && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable boot2docker && cp -u output/* ../output/ ' },
            //        "oracle_rhck" 	    : { sh 'mkdir -p probe/oracle_rhck   && cd probe/oracle_rhck   && docker run -i --rm --name oracle-rhck-build -v ${PWD}:/build/probe fedora-builder sysdig-probe jenkins-pipeline-test stable Oracle_RHCK && cp -u output/* output/ ' },
                    "oracle_rhck" 	    : { sh 'mkdir -p probe/oracle_rhck   && cd probe/oracle_rhck   && bash -x ../../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable Oracle_RHCK && cp -u output/* ../output/ ' },
                    "oracle_linux6_uek" : { sh 'mkdir -p probe               && cd probe               && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable Oracle_Linux_6_UEK' },
                    "oracle_linux7_uek" : { sh 'mkdir -p probe               && cd probe               && bash -x ../sysdig/scripts/build-probe-binaries sysdig-probe jenkins-pipeline-test stable Oracle_Linux_7_UEK' },
                    "amazon_linux" 	    : { sh 'mkdir -p probe/amazon_linux  && cd probe/amazon_linux  && docker run -i --rm --name amazon-linux-build -v ${PWD}:/build/probe fedora-builder sysdig-probe jenkins-pipeline-test stable AmazonLinux && cp -u output/* ../output/ ' },
                    "amazon_linux2" 	: { sh 'mkdir -p probe/amazon_linux2 && cd probe/amazon_linux2 && docker run -i --rm --name amazon-linux2-build -v ${PWD}:/build/probe fedora-builder sysdig-probe jenkins-pipeline-test stable AmazonLinux2 && cp -u output/* ../output/ ' },
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
		sh ' echo "number of files = $(ls -l probe/output/ | wc -l)" '
                sh 'ls -l probe/output/'
		build job: "test-publish-probe-modules", propagate: false, wait: false, parameters: [ string(name: 'WDIR', value: "${WORKSPACE}") ]
		sh ' echo probe modules published'
            }
        }
    }
}
