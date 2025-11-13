# Cloud Architecture on GCP with Terraform & GitHub Actions

This repository contains infrastructure-as-code (IaC) and CI/CD pipelines for deploying a cloud-native application on **Google Cloud Platform (GCP)**.  
The stack includes a React frontend, Java backend, managed MySQL database, optional Redis caching, batch processing with Dataflow/BigQuery, and observability/security services.

---

## 📐 Architecture Overview

- **Frontend**
  - React app hosted on Cloud Storage
  - Served globally via Cloud CDN + HTTPS Load Balancer

- **Backend**
  - Java service deployed on Cloud Run (or GKE for advanced orchestration)
  - Autoscaling, secure networking, IAM-based access

- **Database**
  - Cloud SQL for MySQL with private IP
  - Automated backups, HA, GDPR compliance

- **Caching**
  - Memorystore (Redis) for session/state caching

- **Batch Processing**
  - Dataflow (or Dataproc) for nightly ETL (~5TB)
  - BigQuery for analytics and ML integration

- **Networking**
  - Custom VPC with regional subnets
  - Cloud NAT, Private Google Access
  - Interconnect/VPN for secure migration lanes

- **Traffic Management**
  - Global HTTPS Load Balancer
  - SSL termination, NEG pointing to Cloud Run/GKE

- **Observability**
  - Cloud Monitoring + Cloud Logging
  - Alerting integration with PagerDuty/Slack

- **Security & Compliance**
  - IAM, VPC Service Controls, Cloud Armor
  - DLP for sensitive data scanning
  - Secrets Manager for credentials
  - CMEK for encryption

---



## 🚀 Deployment Flow

1. **Infrastructure Provisioning**
   - Managed via Terraform modules under `infra/`
   - GitHub Actions workflow `terraform-ci.yml` runs `plan` and `apply`
   - Uses Workload Identity Federation for secure, keyless auth to GCP

2. **Application Build & Deploy**
   - Backend container built with Docker
   - Pushed to Artifact Registry / GCR
   - Deployed to Cloud Run (`deploy-cloudrun.yml`) or GKE (`deploy-gke.yml`)
   - Environment variables injected from GitHub Secrets (DB host, Redis host, etc.)

3. **Frontend Deployment**
   - React app built and uploaded to Cloud Storage bucket
   - Served via Cloud CDN + HTTPS Load Balancer

4. **Batch Processing**
   - Dataflow templates stored in GCS
   - Triggered via Cloud Scheduler for nightly ETL
   - Results stored in BigQuery

---

## ⚙️ Prerequisites

- GCP project with billing enabled
- Terraform >= 1.5
- GitHub repository with Actions enabled
- Workload Identity Federation configured between GitHub and GCP
- Docker installed locally (for manual builds)

---

## 🔑 Secrets & Configuration

GitHub Secrets required:
- `DB_HOST`, `DB_USER`, `DB_NAME`, `DB_PASSWORD`
- `REDIS_HOST`
- `GOOGLE_PROJECT_ID`
- `GOOGLE_WORKLOAD_IDENTITY_PROVIDER`
- `GOOGLE_SERVICE_ACCOUNT`

---

## 📈 Observability & Alerts

- Logs collected via Cloud Logging
- Metrics via Cloud Monitoring
- Notification channels (email, Slack, PagerDuty) can be configured in Terraform

---

## 🛡️ Security Notes

- IAM roles follow least privilege
- Secrets stored in Secret Manager
- Cloud Armor policies protect frontend/backend endpoints
- CMEK used for encryption of storage and BigQuery datasets

---

## 🧩 Next Steps

- Add Cloud DNS records for custom domains
- Configure Cloud Armor WAF rules
- Expand CI/CD to include frontend build/deploy
- Add budget alerts and SLO monitoring

---

