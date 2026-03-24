# AWS CloudWatch Monitoring & Observability Lab

## 📋 Overview
This project demonstrates the implementation of a comprehensive monitoring solution on a freshly deployed Amazon EC2 instance. The objective was to simulate a typical operational scenario where observability must be implemented from scratch, including custom metrics, log collection, filtering for errors, and alarm-based alerting.

## 🛠 Architecture & Components
* **Compute**: Amazon EC2 instance (Amazon Linux 2023).
* **Web Server**: Nginx (installed to generate web traffic and logs).
* **Monitoring Agent**: Unified AWS CloudWatch Agent.
* **Configuration Storage**: AWS Systems Manager (SSM) Parameter Store (enabling version control and automation).
* **Notification System**: Amazon SNS (Simple Notification Service).

## 🚀 Implementation Details

### 1. Provisioning & Security
* **Infrastructure**: Deployed a single EC2 instance and installed the Nginx server.
* **IAM & Permissions**: Applied the **Principle of Least Privilege**, granting only the minimum permissions required for the CloudWatch Agent and SNS to perform their tasks.

### 2. Metrics & Logs Collection
* **Custom Metrics**: Configured the agent to push custom metrics (e.g., number of HTTP requests served by Nginx) using the StatsD protocol.
* **Log Management**: Configured a Log Group for system logs (specifically `/var/log/messages`).
* **Retention Policy**: Implemented a log retention policy (7 days) to optimize storage costs and meet operational needs.

### 3. Error Detection & Alerting
* **Metric Filter**: Created a specific metric filter to scan incoming logs and detect "ERROR" entries in real-time.
* **CloudWatch Alarm**: Established an alarm based on the metric filter threshold.
* **Automated Notification**: Integrated the alarm with Amazon SNS to notify operators immediately when errors are detected.

## 🧪 Testing & Validation
Following best practices, the system was manually validated:
* **Manual Log Injection**: Used the terminal to add a test "ERROR" entry to the logs.
* **Metric Verification**: Simulated traffic to verify the successful collection of custom HTTP request data in CloudWatch Metrics.
* **Alarm Confirmation**: Verified that the CloudWatch Alarm transitioned to the `ALARM` state and triggered the SNS email notification.

---
*Note: This documentation is based on the DevOps/Cloud monitoring task requirements.*