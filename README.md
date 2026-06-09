# 🚀 Starbucks-Themed End-to-End CI/CD Pipeline | Jenkins + Kubernetes + Advanced Security

![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-blue?style=for-the-badge&logo=jenkins)
![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker)
![SonarQube](https://img.shields.io/badge/Quality-SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube)
![Security](https://img.shields.io/badge/Security-Trivy-00979D?style=for-the-badge&logo=trivy)
![AWS](https://img.shields.io/badge/Cloud-AWS%20S3-FF9900?style=for-the-badge&logo=amazon-aws)
![Email](https://img.shields.io/badge/Notifications-Email-D14836?style=for-the-badge&logo=gmail)

---

## 📖 The Story Behind This Project

When I started my DevOps journey, I built a basic CI/CD pipeline. It worked, but something felt missing. I realized that **real-world pipelines aren't just about moving code from A to B** — they're about **quality gates, security, observability, and graceful failure handling**.

So I challenged myself to build something closer to what production systems actually look like. The result? This **Starbucks-themed pipeline** — not because it's related to coffee ☕, but because I wanted a memorable project name that stands out in my portfolio.

This pipeline goes beyond the basics:
- ✅ **Quality Gates** that actually stop bad code (not just scan it)
- ✅ **Dual Security Scanning** (filesystem + Docker image)
- ✅ **Kubernetes Integration** for modern deployment
- ✅ **Automated Email Notifications** with scan reports attached
- ✅ **Workspace Cleanup** for consistent builds

Every stage has a purpose. Every tool was chosen deliberately. Let me walk you through it.

---

## 🏗️ Architecture & Flow
    ┌─────────────────────────────────────────────────────────────────┐
    │                        JENKINS PIPELINE                         │
    └─────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
   ┌─────────┐              ┌──────────────┐            ┌──────────┐
   │  Clean  │─────────────▶│  Git Clone   │───────────▶│SonarQube│
   │Workspace│              │(starbucks    │            │ Analysis │
   └─────────┘              │   branch)    │            └────┬─────┘
                            └──────────────┘                 │
                                                             ▼
        ┌────────────────────────────────────────────────────────────┐
        │                    Quality Gate Check                      │
        │         (Pipeline continues even if gate fails)            │
        └────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
        ┌────────────────────────────────────────────────────────────┐
        │              Trivy Filesystem Scan                         │
        │         (Scans dependencies & configs)                     │
        └────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │      Docker Build & Push      │
                    │  (armcool004/starbucks:may)   │
                    └───────────────────────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │    Trivy Docker Image Scan    │
                    │   (Scans final container)     │
                    └───────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
        ┌──────────────────────┐        ┌──────────────────────┐
        │  Kubernetes Deploy   │        │    S3 Artifact       │
        │  (Trigger next job)  │        │      Backup          │
        └──────────────────────┘        └──────────────────────┘
                    │                               │
                    └───────────────┬───────────────┘
                                    ▼
                    ┌───────────────────────────────┐
                    │   Email Notification          │
                    │   (with scan reports)         │
                    └───────────────────────────────┘

---

## 🛠️ Tools & Technologies

| Category | Tool | Why I Chose It |
|----------|------|----------------|
| **CI/CD Server** | Jenkins | Industry standard, highly customizable, massive plugin ecosystem |
| **Version Control** | Git + GitHub | Standard for collaboration and version tracking |
| **Code Quality** | SonarQube | Detects bugs, vulnerabilities, code smells before they reach production |
| **Security Scanning** | Trivy | Fast, comprehensive vulnerability scanner for containers and filesystems |
| **Containerization** | Docker | Consistent environments across dev, test, and production |
| **Container Registry** | Docker Hub | Reliable, widely supported image storage |
| **Orchestration** | Kubernetes | Production-grade container management and scaling |
| **Cloud Storage** | AWS S3 | Durable, scalable artifact backup |
| **Notifications** | Email (SMTP) | Immediate visibility into build status |
| **OS** | Linux (Ubuntu) | Rock-solid foundation for all DevOps tools |

---

## 🔄 Pipeline Stages — Deep Dive

### Stage 1: Clean Workspace 🧹
```groovy
stage('clean') {
    steps {
        cleanWs()
    }
}
Why it matters: Every build starts with a clean slate. No leftover files from previous builds, no stale artifacts. This eliminates "it works on my machine" issues and ensures reproducibility.

Stage 2: Git Clone 📥
stage('git clone') {
    steps {
        git branch: 'starbucks', url: 'https://github.com/armcool007/project_for_cv.git'
    }
}
What happens: Pulls the latest code from the starbucks branch. I use a specific branch (not main) to demonstrate feature-branch workflows.

Stage 3: SonarQube Analysis 🔍
stage('sonarqube test') {
    steps {
        withSonarQubeEnv('sonarqube') {
            sh '$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=starbucks -Dsonar.projectKey=starbucks'
        }
    }
}
What it does: Scans the entire codebase for:

    🐛 Bugs and logic errors
    🔒 Security vulnerabilities
    📊 Code smells and maintainability issues
    📈 Code coverage (if tests exist)

Real-world impact: In a team setting, this catches issues before code review even starts.

Stage 4: Quality Gate Check 🚦
stage('qualitygates'){
    steps{
        waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-id'
    }
}
What it does: Waits for SonarQube to finish analysis and checks if the code meets quality standards.
Why abortPipeline: false? I set it to false because I want visibility into quality issues without blocking the entire pipeline. In a stricter environment, you'd set this to true to fail fast.

Stage 5: Trivy Filesystem Scan 🛡️
stage('trivy fs scan') {
    steps {
        sh 'trivy fs . > starFS.txt'
    }
}
What it scans:

    Dependencies in package.json, requirements.txt, pom.xml, etc.
    Configuration files with hardcoded secrets
    Known vulnerabilities in third-party libraries

Output: Saved to starFS.txt for later review and email attachment.

Stage 6: Docker Build 🐳
stage('docker build') {
    steps {
        sh 'docker build -t armcool004/starbucks:may .'
    }
}

Stage 7: Docker Push 📤
stage('docker push') {
    steps {
        withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
            sh 'docker push armcool004/starbucks:may'
        }
    }
}
Security note: Credentials are stored in Jenkins Credentials Manager, not hardcoded. This is non-negotiable in any real pipeline.

Stage 8: Trivy Image Scan 🔐
Why scan the image? The filesystem scan checks your code, but the image scan checks the entire container including:

    Base OS vulnerabilities (Ubuntu, Alpine, etc.)
    System libraries
    Installed packages

This is shift-left security in action. Catch vulnerabilities before deployment, not after a breach.

Stage 9: Kubernetes Deployment ☸️
stage('hitting kuber'){
    steps{
        build 'starbuks-kubernets'
    }
}
What happens: Triggers another Jenkins job (starbuks-kubernets) that handles the actual Kubernetes deployment.
Why separate job? Separation of concerns. The CI pipeline builds and tests; the CD pipeline deploys. This allows:

    Independent scaling of CI and CD
    Different approval workflows
    Easier rollback strategies

Stage 10: S3 Artifact Backup ☁️
stage('save data in s3'){
    steps{
        s3Upload(
            profileName: 'jenkins_s3_role',
            entries: [[
                sourceFile: '**/*',
                bucket: 'outoftheworld9',
                selectedRegion: 'ap-south-1'
            ]],
            // ... additional config
        )
    }
}
What gets backed up: Everything — source code, scan reports, Dockerfiles, Kubernetes manifests.
Why S3? Durability (99.999999999%), versioning, and easy integration with other AWS services.
Security: Uses IAM role (jenkins_s3_role) instead of access keys. Never hardcode AWS credentials!

Post-Action: Email Notification 📧
post {
    always {
        script {
            emailext (
                subject: "Pipeline ${buildStatus}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """...""",
                attachmentsPattern: '**/imageSCAN.txt,**/starFS.txt'
            )
        }
    }
}
This is where the magic happens. Regardless of success or failure, stakeholders get:

    ✅ Build status (SUCCESS/FAILURE/UNSTABLE)
    ✅ Build number and URL
    ✅ Who triggered the build
    ✅ Scan reports attached (both filesystem and image scans)


🎯 Key Features That Set This Apart
1. Quality Gates with Graceful Degradation
Unlike basic pipelines that either pass or fail, this pipeline provides visibility into quality issues without blocking deployment. You can adjust abortPipeline based on your risk tolerance.
2. Dual Security Scanning
Most projects scan either the filesystem OR the Docker image. I scan both because:

    Filesystem scan catches dependency vulnerabilities early
    Image scan catches OS-level and runtime vulnerabilities

3. Automated Reporting
Scan reports aren't just saved — they're emailed to stakeholders. This creates accountability and ensures security issues don't go unnoticed.
4. Kubernetes Integration
By triggering a separate Kubernetes job, this pipeline demonstrates microservices architecture and separation of concerns — critical for enterprise environments.
5. Workspace Cleanup
Starting every build with a clean workspace eliminates a whole class of "mysterious" build failures.

🚀 How to Run This Pipeline
Prerequisites

    Jenkins server with required plugins:
        Git
        Docker Pipeline
        SonarQube Scanner
        Trivy
        AWS Credentials
        Email Extension
    SonarQube server configured in Jenkins
    Docker installed and running
    Docker Hub account and credentials in Jenkins
    AWS CLI configured with IAM role
    S3 bucket created (outoftheworld9 in ap-south-1)
    Kubernetes cluster accessible (for deployment stage)

**Steps:**
1) Clone this repository:
    git clone https://github.com/armcool007/project_for_cv.git
    cd project_for_cv

2) Create a new Jenkins Pipeline job:
    Go to Jenkins Dashboard → New Item
    Enter name: starbucks-cicd
    Select "Pipeline" → OK

3) Configure the pipeline:
    Pipeline → Definition: "Pipeline script from SCM"
    SCM: Git
    Repository URL: https://github.com/armcool007/project_for_cv.git
    Branch: */starbucks
    Script Path: Jenkinsfile

4) Build the job:
    Click "Build Now"
    Watch the magic happen in Blue Ocean UI

5) Check results:
    Jenkins console output
    SonarQube dashboard
    Docker Hub repository
    S3 bucket
    Your inbox (email notification)
