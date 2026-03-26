# Kubernetes DevSecOps Pipeline

![Python](https://img.shields.io/badge/python-3.11-blue)
![Docker](https://img.shields.io/badge/docker-containerized-blue)
![Kubernetes](https://img.shields.io/badge/kubernetes-native-blue)
![Semgrep](https://img.shields.io/badge/SAST-Semgrep-blueviolet)
![Trivy](https://img.shields.io/badge/SCA-Trivy-green)
![OWASP ZAP](https://img.shields.io/badge/DAST-OWASP%20ZAP-orange)
![GitHub Actions](https://img.shields.io/badge/CI/CD-GitHub%20Actions-black)
![License](https://img.shields.io/badge/license-MIT-green)

A Kubernetes-native DevSecOps pipeline that integrates **SAST, SCA, and DAST security testing** into a CI/CD workflow.  

This project demonstrates how to build, scan, and deploy a containerized application while automatically detecting vulnerabilities across the entire SDLC.

Repository:  
https://github.com/sassenagh/k8s-devsecops-pipeline

---

# Architecture

The pipeline runs in GitHub Actions using a self-hosted runner (Mac) for deployment and security tools executed in containers.

```
    GitHub Push
         │
         ▼
  GitHub Actions Workflow
          │
┌─────────┴─────────┐
│                   │
▼                   ▼
SAST (Semgrep)   SCA (Trivy)
│                   │
└─────────┬─────────┘
          ▼
   Docker Image Build
          │
          ▼
 Kubernetes Deployment
          │
          ▼
   Port Forward (Local)
          │
          ▼
 DAST (OWASP ZAP Scan)
          │
          ▼
     Security Report

```

Deployment workflow:

```
Code → CI/CD → Security Scans → Docker → Kubernetes → DAST → Report
```

---

# Features

- Static Application Security Testing (**SAST**) using **Semgrep**  
- Software Composition Analysis (**SCA**) using **Trivy**  
- Dynamic Application Security Testing (**DAST**) using **OWASP ZAP**  
- Containerized application with Docker  
- Kubernetes-native deployment (Docker Desktop K8s)  
- GitHub Actions CI/CD pipeline  
- Self-hosted runner execution  
- Automated security scanning across the SDLC  
- ZAP report generation and artifact upload  
- Intentional vulnerabilities (XSS) for testing security tools  

---

# Tech Stack

## Backend

- Python 3.11  
- Flask  

## Security

- **Semgrep (SAST)**  
- **Trivy (SCA)**  
- **OWASP ZAP (DAST)**  

## Infrastructure

- Docker  
- Kubernetes (Docker Desktop)  

## CI/CD

- GitHub Actions (self-hosted runner)

---

# Project Structure

```
k8s-devsecops-pipeline
│
├── app
│   │── main.py # Vulnerable Flask app (XSS example)
│   └── requirements.txt
│
├── k8s
│   │── deployment.yaml # Kubernetes Deployment
│   └── service.yaml # Kubernetes Service
│
├── Dockerfile
├── .github/workflows
│   └── pipeline.yaml # DevSecOps pipeline
│
└── README.md
```

---

# How It Works

1. Code is pushed to the repository.  
2. GitHub Actions pipeline is triggered.  
3. **SAST (Semgrep)** scans the source code.  
4. Docker image is built.  
5. **SCA (Trivy)** scans the image for vulnerabilities.  
6. Application is deployed to Kubernetes.  
7. Port-forward exposes the service locally.  
8. **DAST (ZAP)** scans the running application. 

---

# Running Locally

Clone the repository:

```bash
git clone https://github.com/sassenagh/k8s-devsecops-pipeline.git
cd k8s-devsecops-pipeline
```

Build the Docker image:

```bash
docker build -t vulnerable-app:latest .
```

Run the application locally:

```bash
docker run -p 5000:5000 vulnerable-app:latest
```

Test the vulnerable endpoint:

```bash
curl "http://localhost:5000/greet?name=<script>alert(1)</script>"
```

Deploy to Kubernetes (Docker Desktop):

```bash
kubectl apply -f k8s/
```

Expose the service:

```bash
kubectl port-forward svc/vulnerable-app 9090:80
```

Access the app:

```bash
http://localhost:9090
```

---

# GitHub Actions Workflow

- Triggered on push to master with changes in:
    - `app/**`
    - `k8s/**`
    - `Dockerfile`
- Runs on a **self-hosted runner (Mac)**
- Executes the full DevSecOps pipeline:
    - SAST → Semgrep
    - Build → Docker
    - SCA → Trivy
    - Deploy → Kubernetes
    -  → OWASP ZAP
- Uses Docker containers for security tools
- Uploads ZAP report as an artifact

Example workflow trigger:
```
on:
  push:
    paths:
      - Dockerfile
      - "app/**"
      - "k8s/**"
    branches:
      - master
```

---

# Future Improvements

- Run DAST in a dedicated Linux runner for improved stability
- Fail pipeline on critical vulnerabilities (security gates)
- Add severity thresholds and policy enforcement
- Integrate notifications (Slack, email)
- Store reports in external storage (S3, GCS)
- Add Helm charts for Kubernetes deployment
- Extend vulnerable app with more real-world security issues

---

# License

MIT License