import json
import os
import urllib3
import boto3
from datetime import datetime, timedelta, timezone

ec2_client = boto3.client('ec2')
cw_client = boto3.client('cloudwatch')
http = urllib3.PoolManager()

SLACK_WEBHOOK_URL = os.environ.get('SLACK_WEBHOOK_URL')

def send_slack_notification(app_group, stressed_instances):
    message = {
        "text": f"CRITICAL GROUP ALERT\n"
                f"Application Group: {app_group}\n"
                f"Quorum failure detected. The following instances are under sustained stress: {', '.join(stressed_instances)}.\n"
                f"Immediate intervention required."
    }
    
    encoded_msg = json.dumps(message).encode('utf-8')
    response = http.request('POST', SLACK_WEBHOOK_URL, body=encoded_msg, headers={'Content-Type': 'application/json'})
    return response.status

def get_prod_instances():
    response = ec2_client.describe_instances(
        Filters=[
            {'Name': 'tag:Env', 'Values': ['prod']},
            {'Name': 'tag:AutoAlert', 'Values': ['true']}
        ]
    )
    instances = []
    for reservation in response['Reservations']:
        for inst in reservation['Instances']:
            instances.append(inst)
    return instances

def group_instances_by_app(instances):
    grouped = {}
    for inst in instances:
        instance_id = inst['InstanceId']
        app_tag = next((tag['Value'] for tag in inst.get('Tags', []) if tag['Key'] == 'App'), 'unknown')
        
        if app_tag not in grouped:
            grouped[app_tag] = []
        grouped[app_tag].append(instance_id)
        
    return grouped

def check_sustained_stress(instance_ids):
    stressed = []
    end_time = datetime.now(timezone.utc)
    start_time = end_time - timedelta(minutes=5)
    
    for i_id in instance_ids:
        response = cw_client.get_metric_data(
            MetricDataQueries=[
                {
                    'Id': 'm1',
                    'MetricStat': {
                        'Metric': {'Namespace': 'AWS/EC2', 'MetricName': 'CPUUtilization', 'Dimensions': [{'Name': 'InstanceId', 'Value': i_id}]},
                        'Period': 300,
                        'Stat': 'Average'
                    }
                },
                {
                    'Id': 'm2',
                    'MetricStat': {
                        'Metric': {'Namespace': 'CWAgent', 'MetricName': 'cpu_usage_iowait', 'Dimensions': [{'Name': 'InstanceId', 'Value': i_id}]},
                        'Period': 300,
                        'Stat': 'Average'
                    }
                },
                {
                    'Id': 'm3',
                    'MetricStat': {
                        'Metric': {'Namespace': 'CWAgent', 'MetricName': 'disk_used_percent', 'Dimensions': [{'Name': 'InstanceId', 'Value': i_id}]},
                        'Period': 300,
                        'Stat': 'Average'
                    }
                },
                {
                    'Id': 'm4',
                    'MetricStat': {
                        'Metric': {'Namespace': 'CWAgent', 'MetricName': 'bytes_sent', 'Dimensions': [{'Name': 'InstanceId', 'Value': i_id}]},
                        'Period': 300,
                        'Stat': 'Average'
                    }
                }
            ],
            StartTime=start_time,
            EndTime=end_time
        )
        
        results = {res['Id']: res['Values'][0] if res['Values'] else 0 for res in response['MetricDataResults']}
        
        cpu_high = results.get('m1', 0) > 80
        iowait_high = results.get('m2', 0) > 20
        disk_high = results.get('m3', 0) > 85
        net_high = results.get('m4', 0) > 524288000
        
        if cpu_high and iowait_high and disk_high and net_high:
            stressed.append(i_id)
            
    return stressed

def lambda_handler(event, context):
    print("Received EventBridge event:", json.dumps(event))
    
    prod_instances = get_prod_instances()
    grouped_instances = group_instances_by_app(prod_instances)
    
    for app_group, instance_ids in grouped_instances.items():
        print(f"Analyzing group: {app_group} (Instances: {instance_ids})")
        
        stressed_instances = check_sustained_stress(instance_ids)
        
        if len(stressed_instances) >= 2: 
            print(f"Failure quorum reached for group {app_group}. Sending Slack notification.")
            send_slack_notification(app_group, stressed_instances)
        else:
            print(f"Group {app_group} is stable or failure is isolated. Ignoring.")

    return {
        'statusCode': 200,
        'body': json.dumps('Alert evaluation completed successfully.')
    }