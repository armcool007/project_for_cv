# 🚀 End-to-End CI/CD Pipeline with Jenkins, Docker, SonarQube, Trivy & AWS S3

![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-blue)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker)
![SonarQube](https://img.shields.io/badge/Code%20Quality-SonarQube-green)
![Security](https://img.shields.io/badge/Security-Trivy-red)
![AWS](https://img.shields.io/badge/Cloud-AWS%20S3-orange?logo=amazon-aws)

## 📌 Project Overview

This project demonstrates a **production-grade CI/CD pipeline** built using **Jenkins** that automates the entire software delivery lifecycle — from code checkout to deployment and artifact storage. The pipeline integrates **code quality analysis**, **security scanning**, **containerization**, and **cloud-based artifact management**, reflecting real-world DevOps practices.

The core philosophy: **"Automate everything that can be automated."**

---

## 🏗️ Architecture / Pipeline Flow

──────────┐    ┌────────────┐    ┌──────────┐    ┌──────────────┐
│ Git Repo │───▶│ SonarQube  │───▶│  Trivy   │───▶│ Docker Build │
└──────────┘    │(Code Scan) │    │(FS Scan) │    └──────┬───────┘
                └────────────┘    └──────────┘           │
                                                         ▼
┌──────────┐    ┌────────────┐    ┌──────────┐    ┌──────────────┐
│   S3     │◀───│Docker Push │◀───│Docker Run│◀───│Docker Registry│
│ (Backup) │    └────────────┘    └──────────┘    │ (Docker Hub) │
└──────────┘                                       └──────────────┘



---

## 🛠️ Tools & Technologies Used

| Category        | Tool                          |
|-----------------|-------------------------------|
| CI/CD Server    | Jenkins                       |
| Version Control | Git & GitHub                  |
| Code Quality    | SonarQube + SonarScanner      |
| Security Scan   | Trivy (Filesystem & Image)    |
| Containerization| Docker                        |
| Registry        | Docker Hub                    |
| Cloud Storage   | AWS S3                        |
| OS              | Linux (Ubuntu/Amazon Linux)   |
| Scripting       | Bash, Jenkinsfile (Groovy)    |

---

## 🔄 Pipeline Stages Explained

### 1️⃣ Git Clone
Pulls the latest source code from the `main` branch of the GitHub repository.

### 2️⃣ SonarQube Analysis
Performs **static code analysis** to detect bugs, code smells, and security vulnerabilities. Ensures code quality gates are met before proceeding.

### 3️⃣ Trivy Filesystem Scan
Scans the project filesystem for **vulnerabilities in dependencies and configuration files**.

### 4️⃣ Docker Build
Builds a Docker image from the `Dockerfile` and tags it as `armcool004/project_maven`.

### 5️⃣ Docker Push
Pushes the built image to **Docker Hub** using stored credentials (`docker-cred`).

### 6️⃣ Docker Run
Runs the containerized application in detached mode on port `8081`, mapped to container port `8080`.

### 7️⃣ S3 Artifact Upload
Uploads build artifacts to an **AWS S3 bucket** (`outoftheworld9`) for backup and traceability using IAM role-based authentication.

---

## ✅ Prerequisites

Before running this pipeline, ensure the following are installed and configured:

- [ ] Jenkins server running (with required plugins)
- [ ] Git installed on the Jenkins agent
- [ ] SonarQube server configured in Jenkins (`Manage Jenkins → Configure System`)
- [ ] Trivy installed on the Jenkins agent
- [ ] Docker installed and running
- [ ] Docker Hub credentials added in Jenkins (`docker-cred`)
- [ ] AWS CLI configured with IAM role `jenkins_s3_role` having S3 access
- [ ] S3 bucket `outoftheworld9` created in `ap-south-1` region

---

## 🚀 How to Use
1) Clone this repository:
   ```bash
   git clone https://github.com/armcool007/project_for_cv.git
   cd project_for_cv
   
2)Place the Jenkinsfile in your Jenkins job configuration (Pipeline → Pipeline script from SCM).

3)Trigger the build from Jenkins dashboard.

4)Monitor each stage in the Jenkins Blue Ocean UI.

5)Access the running application at:
    http://<jenkins-server-ip>:8081
