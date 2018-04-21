dockerArgs = '-u root:root -v /var/cache/gradle:/tmp/.gradle:rw -e GRADLE_USER_HOME=/tmp/.gradle'
def gradleTask(String task) {
    "./gradlew $task --no-daemon"
}


pipeline {
    agent none
    stages {
        stage('Checks') {
            parallel {
                stage('Unit test') {
                    agent {
                        dockerfile {
                            label 'docker-medium'
                            args dockerArgs
                            customWorkspace UUID.randomUUID().toString()
                        }
                    }
                    steps {
                        sh gradleTask("test")
                    }
                }

                stage('Static analysis') {
                    agent {
                        dockerfile {
                            label 'docker-medium'
                            args dockerArgs
                            customWorkspace UUID.randomUUID().toString()
                        }
                    }
                    steps {
                        sh gradleTask("lint")
                    }
                }
 		node('TestSlave1') {
                    stage ('configure') {
                        sh "echo a"
                    }
                    stage ('make') {
                        sh "echo a"
                    }
                    stage ('test') {
                        sh "echo a"
                    }
                }

                stage('UI test') {
                    agent {
                        dockerfile {
                            label 'docker-medium'
                            args dockerArgs
                            customWorkspace UUID.randomUUID().toString()
                        }
                    }
                    steps {
                        sh gradleTask("test")
                    }
                }

            }
        }

        stage('Build') {
            agent {
                dockerfile {
                    label 'docker-medium'
                    args dockerArgs
                    customWorkspace UUID.randomUUID().toString()
                }
            }
            steps {
                sh gradleTask("assembleRelease")
            }
        }

        stage('Upload TestObject') {
            agent {
                dockerfile {
                    label 'docker-medium'
                    args dockerArgs
                }
            }
            steps {
                sh 'curl -u "citrixguest:475DCF1D01E443488736AD4769ED56E9" -X POST https://app.testobject.com:443/api/storage/upload -H "Content-Type: application/octet-stream" --data-binary @./app/build/outputs/apk/release/app-release.apk'
                sh 'echo "Successfully uploaded to TestObject"'
            }
        }

        stage('Publish') {
            agent {
                dockerfile {
                    label 'docker-medium'
                    args dockerArgs
                }
            }
            steps {
                sh 'fastlane supply init'
                sh 'fastlane publishBeta'
                sh "echo done"
            }
        }
    }

}
