/*
 * Beancount-Trans-Assets 多分支流水线（Jenkins Multibranch Pipeline）
 *
 * 该仓库是 Fava 运行镜像（dhr2333/beancount-trans-assets）的构建来源：
 *   构建本目录 Dockerfile → 冒烟校验（fava / beancount 版本与插件）→ 推送 Docker Hub。
 *
 * 镜像标签规则：
 *   - 所有分支推送 git-<short-sha>；
 *   - main 分支额外推送 latest（主仓库 docker-compose 通过 FAVA_IMAGE 拉取该标签）。
 *
 * 依赖版本统一由 requirements.txt 维护（beancount / fava 钉版）；
 * 升级时改动 requirements.txt（可用 python:3.12-slim 重新 pip freeze 生成）后提交，
 * 本流水线会重新构建并通过冒烟校验，保证镜像可用后再推送。
 */

pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        DOCKERHUB_REPO = 'dhr2333/beancount-trans-assets'
        // 构建期间需临时停止的容器（释放内存），构建结束后在 post.always 统一启动
        SUSPENDED_CONTAINERS = 'beancount-trans-beat odoo19'
    }

    stages {
        stage('初始化') {
            steps {
                script {
                    echo "🚀 开始构建 Beancount-Trans-Assets（Fava 运行镜像）"
                    echo "分支: ${env.BRANCH_NAME}"

                    env.GIT_COMMIT_SHORT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                    env.IMAGE_TAG = "git-${env.GIT_COMMIT_SHORT}"

                    echo "Git Commit短哈希: ${env.GIT_COMMIT_SHORT}"
                    echo "镜像标签: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('停止占用内存的容器') {
            steps {
                echo "⏹️ 构建前停止占用内存的容器（${env.SUSPENDED_CONTAINERS}）..."
                sh 'docker stop ${SUSPENDED_CONTAINERS} 2>/dev/null || true'
            }
        }

        stage('构建镜像') {
            steps {
                retry(3) {
                    sh '''
                        echo "🐳 构建镜像..."
                        docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('冒烟校验') {
            steps {
                sh '''
                    set -e
                    echo "🧪 校验镜像内 fava / beancount 版本与插件可用性..."
                    docker run --rm ${DOCKERHUB_REPO}:${IMAGE_TAG} fava --version
                    docker run --rm ${DOCKERHUB_REPO}:${IMAGE_TAG} python -c "import beancount.plugins.auto_accounts, beancount.plugins.unique_prices, fava; from importlib.metadata import version; print(version('beancount'), version('fava'))"
                    echo "✅ 冒烟校验通过"
                '''
            }
        }

        stage('推送镜像') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-dhr2333',
                                                  usernameVariable: 'DOCKERHUB_USER',
                                                  passwordVariable: 'DOCKERHUB_TOKEN')]) {
                    sh '''
                        set -e
                        echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USER}" --password-stdin

                        if [ "${BRANCH_NAME}" = "main" ]; then
                            docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                        fi

                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}

                        if [ "${BRANCH_NAME}" = "main" ]; then
                            docker push ${DOCKERHUB_REPO}:latest
                        fi

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ 构建成功 | 镜像: ${env.DOCKERHUB_REPO}:${env.IMAGE_TAG}"
        }
        failure {
            echo '❌ 构建或校验失败'
        }
        always {
            script {
                echo "▶️ 重新启动构建前停止的容器（${env.SUSPENDED_CONTAINERS}）..."
                sh 'docker start ${SUSPENDED_CONTAINERS} 2>/dev/null || true'
            }
            cleanWs()
        }
    }
}
