pipeline {
     agent any
     triggers {
          pollSCM('* * * * *')
     }
     environment {
          BUILD_TIMESTAMP = sh(script: 'date +%Y%m%d%H%M%S', returnStdout: true).trim()
          DOCKER_IMAGE = "imarif28/calculator:${BUILD_TIMESTAMP}"
          KUBECONFIG = credentials('kubeconfig')
     }
     stages {
          stage("Compile") {
               steps {
                    sh "./gradlew compileJava"
               }
          }
          stage("Unit test") {
               steps {
                    sh "./gradlew test"
               }
          }
          stage("Code coverage") {
               steps {
                    sh "./gradlew jacocoTestReport"
                    sh "./gradlew jacocoTestCoverageVerification"
               }
          }
          stage("Static code analysis") {
               steps {
                    sh "./gradlew checkstyleMain"
               }
          }
          stage("Package") {
               steps {
                    sh "./gradlew build"
               }
          }

          stage("Docker build and push") {
               steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                         sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                         sh "docker build -t ${DOCKER_IMAGE} ."
                         sh "docker push ${DOCKER_IMAGE}"
                    }
               }
          }

          stage("Update version") {
               steps {
                    sh "sed  -i 's/{{VERSION}}/${BUILD_TIMESTAMP}/g' deployment.yaml"
               }
          }
          
          stage("Deploy to staging") {
               steps {
                    sh "kubectl --context kind-staging apply -f hazelcast.yaml"
                    sh "kubectl --context kind-staging apply -f deployment.yaml"
                    sh "kubectl --context kind-staging apply -f service.yaml"
               }
          }

          stage("Acceptance test") {
               steps {
                    sleep 60
                    sh "chmod +x acceptance-test.sh && ./acceptance-test.sh"
               }
          }


          stage("Release") {
               steps {
                    sh "kubectl --context kind-production apply -f hazelcast.yaml"
                    sh "kubectl --context kind-production apply -f deployment.yaml"
                    sh "kubectl --context kind-production apply -f service.yaml"                    
               }
          }
          stage("Smoke test") {
              steps {
                  sleep 60
                  sh "chmod +x smoke-test.sh && ./smoke-test.sh"
              }
          }
     }
}