# AWS CloudWatch Monitoring & Observability Lab

## 📋 Overview
[cite_start]This project demonstrates the implementation of a comprehensive monitoring solution on a freshly deployed Amazon EC2 instance[cite: 2, 3]. [cite_start]The objective was to simulate a typical operational scenario where observability must be implemented from scratch, including custom metrics, log collection, filtering for errors, and alarm-based alerting[cite: 4].

## 🛠 Architecture & Components
* [cite_start]**Compute**: Amazon EC2 instance (Amazon Linux 2023)[cite: 6].
* [cite_start]**Web Server**: Nginx (installed to generate web traffic and logs)[cite: 6].
* [cite_start]**Monitoring Agent**: Unified AWS CloudWatch Agent[cite: 7].
* [cite_start]**Configuration Storage**: AWS Systems Manager (SSM) Parameter Store (enabling version control and automation)[cite: 17].
* [cite_start]**Notification System**: Amazon SNS (Simple Notification Service)[cite: 12].

## 🚀 Implementation Details

### 1. Provisioning & Security
* [cite_start]**Infrastructure**: Deployed a single EC2 instance and installed the Nginx server[cite: 3, 6].
* [cite_start]**IAM & Permissions**: Applied the **Principle of Least Privilege**, granting only the minimum permissions required for the CloudWatch Agent and SNS to perform their tasks[cite: 15, 16].

### 2. Metrics & Logs Collection
* [cite_start]**Custom Metrics**: Configured the agent to push custom metrics (e.g., number of HTTP requests served by Nginx) using the StatsD protocol[cite: 8, 9].
* [cite_start]**Log Management**: Configured a Log Group for system logs (specifically `/var/log/messages`)[cite: 10].
* [cite_start]**Retention Policy**: Implemented a log retention policy (7-30 days) to optimize storage costs and meet operational needs[cite: 18, 19].

### 3. Error Detection & Alerting
* [cite_start]**Metric Filter**: Created a specific metric filter to scan incoming logs and detect "ERROR" entries in real-time[cite: 11].
* [cite_start]**CloudWatch Alarm**: Established an alarm based on the metric filter threshold[cite: 12].
* [cite_start]**Automated Notification**: Integrated the alarm with Amazon SNS to notify operators immediately when errors are detected[cite: 12, 13].

## 🧪 Testing & Validation
Following best practices, the system was manually validated:
* [cite_start]**Manual Log Injection**: Used the `logger` command to add a test "ERROR" entry to the logs[cite: 21].
* [cite_start]**Metric Verification**: Simulated traffic to verify the successful collection of custom HTTP request data[cite: 21].
* [cite_start]**Alarm Confirmation**: Verified that the CloudWatch Alarm transitioned to the `ALARM` state and triggered the SNS notification[cite: 20].

---
[cite_start]*Note: This documentation is based on the DevOps/Cloud monitoring task requirements[cite: 1, 5].*