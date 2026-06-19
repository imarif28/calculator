pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub')
        KUBECONFIG_FILE = credentials('kubeconfig')
        IMAGE_NAME = "imarif28/calculator"
        IMAGE_TAG = "${BUILD_NUMBER}"
	JAVA_HOME = "/opt/java/openjdk"
    }
    stages {
        stage('Compile and Test') {
            steps {
                sh './gradlew clean build'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Push Docker Image') {
            steps {
                sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin"
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        stage('Deploy to Staging') {
            steps {
                withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                    sh "sed -i 's|REPLACE_ME|${IMAGE_TAG}|g' k8s/deployment.yaml"
                    sh "kubectl --context kind-staging apply -f k8s/--insecure-skip-tls-verify=true"
                }
            }
        }
        stage('Acceptance Test') {
            steps {
                sh "sleep 15"
                echo "Simulasi pengujian fungsional pada lingkungan staging dieksekusi..."
            }
        }
        stage('Deploy to Production') {
            steps {
                withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                    sh "kubectl --context kind-production apply -f k8s/"
                }
            }
        }
        stage('Smoke Test') {
            steps {
                sh "sleep 15"
                echo "Simulasi validasi rilis akhir pada lingkungan produksi dieksekusi..."
            }
        }
    }
}
