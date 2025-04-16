import 'dart:io';

class Config {
  // Server configuration
  final String host;
  final int port;
  final String environment;
  
  // Candidate info
  final String resumeText;
  final String resumeUrl;
  final String linkedinUrl;
  final String websiteUrl;
  
  // Job search parameters
  final String minSalary;
  final String maxSalary;
  final String jobLocation;
  final String companyType;
  
  // Server info
  final String serverName;
  final String serverVersion;

  Config({
    // Server configuration
    String? host,
    String? portStr,
    String? environment,
    
    // Candidate info
    String? resumeText,
    String? resumeUrl,
    String? linkedinUrl,
    String? websiteUrl,
    
    // Job search parameters
    String? minSalary,
    String? maxSalary,
    String? jobLocation,
    String? companyType,
    
    // Server info
    String? serverName,
    String? serverVersion,
  }) : 
    host = host ?? Platform.environment['HOST'] ?? '0.0.0.0',
    port = int.tryParse(portStr ?? Platform.environment['PORT'] ?? '3000') ?? 3000,
    environment = environment ?? Platform.environment['ENVIRONMENT'] ?? 'development',
    resumeText = resumeText ?? Platform.environment['RESUME_TEXT'] ?? _defaultResumeText,
    resumeUrl = resumeUrl ?? Platform.environment['RESUME_URL'] ?? 'https://jakegaylor.com/JakeGaylor_resume.pdf',
    linkedinUrl = linkedinUrl ?? Platform.environment['LINKEDIN_URL'] ?? 'https://linkedin.com/in/jhgaylor',
    websiteUrl = websiteUrl ?? Platform.environment['WEBSITE_URL'] ?? 'https://jakegaylor.com',
    minSalary = minSalary ?? Platform.environment['MIN_SALARY'] ?? '200000',
    maxSalary = maxSalary ?? Platform.environment['MAX_SALARY'] ?? '300000',
    jobLocation = jobLocation ?? Platform.environment['JOB_LOCATION'] ?? 'Remote',
    companyType = companyType ?? Platform.environment['COMPANY_TYPE'] ?? 'Startup',
    serverName = serverName ?? Platform.environment['SERVER_NAME'] ?? 'me-mcp-server',
    serverVersion = serverVersion ?? Platform.environment['SERVER_VERSION'] ?? '1.0.0';
    
  static final Config instance = Config();
  
  static const _defaultResumeText = """
About me
• Nearly 15 years of experience working up and down the web stack, from operations to front end
• Operated a petabyte scale big data infrastructure on AWS EC2 (Cassandra, Kafka, Spark via EMR)
• Big fan of Kubernetes, Gitops, immutable infrastructure, and 12 Factor Apps
• Developed CI and CD pipelines to empower teams to ship better software, faster
• Administered Kubernetes clusters on EKS, GKE, and vSphere (CentOS & CoreOS)
• Serial Entrepreneur. I've done SaaS, PaaS, a physical product, and run a restaurant.
Experience
STAFF SWE, OFFICE OF THE CEO @ CLOAKED INC — AUGUST 2023-PRESENT
• Created a program to ingest ideas from all over the company reflecting the status back to everyone.
• Worked with executives, product management, and marketing to turn shower thoughts into
marketable ideas.
• Documented the function of all people and ceremonies within the ideation process to hand off the
role of researcher to another engineer.
STAFF PLATFORM ENGINEER @ CLOAKED INC — SEPTEMBER 2022-AUGUST 2023
• Migrated all the software stacks from various PaaS providers to AWS EKS
• Used Cloudflare to mask third party usage and give us a layer of control if a provider goes down.
• Migrated a single shared AWS account to a spoke and wheel model meeting compliance obligations
for SOC2 1 and 2, ISO 27001 and 27701.
• Established patterns for deploying applications in the Kubernetes cluster as well as to the edge
network allowing teams to release new software and maintain compliance.
OWNER / CO-GM @ THE ONWARD STORE STEAKHOUSE — OCTOBER 2021-JANUARY 2024
• Managed physical infrastructure including the building, grounds, utilities, network, a/v
• Handled Hiring, Firing, HR, Taxes and Legal responsibilities
• Worked vendors to keep selection fresh and food margins within tolerance
• Developed processes and trained staff to serve more fresh never frozen food
Jake Gaylor
FOUNDER, BUSINESS MINDED ENGINEER, SRE ROOTS <3 KUBERNETES
720.453.3994 jhgaylor@gmail.com http://jakegaylor.com Remote First, Will Travel
STAFF SWE IN DEVELOPER EXPERIENCE @ INCEPTION HEALTH — JUNE 2020-JUNE 2022
• Built AWS infrastructure and CDK packages to maintain HIPAA Compliance obligations while
allowing teams to deliver software on their own schedule.
• Trained product teams to work in a serverless environment and maintain grpc contracts despite
limitations of AWS infrastructure.
SENIOR PLATFORM ENGINEER @ CYBERGRX — DECEMBER 2018-JUNE 2020
• Led vision on the cloud native CI / CD pipelines for AWS and Kubernetes
• Developed a custom resource using the CoreOS operator SDK for orchestrating blue/green deploys
of a "distributed monolith"
• Mentored software engineers in best practices for building and deploying software
SENIOR CLOUD PLATFORM ENGINEER @ CARDFREE — JANUARY 2018-DECEMBER 2018
• Managed a large scale PCI compliant C# installation in AWS
• Established best practices for reliably building software and managing incident response
SENIOR DEVOPS ENGINEER @ PROTECTWISE, INC — AUGUST 2016-JANUARY 2018
• SRE for a massive scale data ingestion platform. Thousands of Cassandra nodes, Petabytes in s3.
\$10M+/yr production AWS environment managed with IaC.
DEVOPS ENGINEER @ FOOD SERVICE WAREHOUSE — JUNE 2015-MARCH 2016
• Using CoreOS, fleet, etcd, flannel and some Jenkins built Kubernetes clusters on vSphere
SOFTWARE DEVELOPER @ MISSISSIPPI STATE UNIVERSITY — JUNE 2010 – JUNE 2014
• Created grant proposals to fund the custom software the university needed to support research
initiatives such as tracking "human sensors" through natural disasters including Hurricane Sandy.
Skills
Programming Languages: Javascript, Python, Bash, Go, Ruby
Databases: Neo4j, postgresql, Timestream, MongoDB, Redis, Etcd, Zookeeper, Cassandra, DynamoDB
Distributed Systems Glue: Argo Workflows, Kafka, RabbitMQ, AWS IoT
Automation: Argo CD, Packer, Terraform, Vagrant, Linux, Chef, Gitlab CI, Jenkins, Github Actions
Orchestration: Kubernetes, Fleet, Docker
Monitoring: Prometheus, CloudWatch, Sensu, Pagerduty, Logstash, Kibana, Grafana, Graphite
Learn more at https://jakegaylor.com or https://github.com/jhgaylor
""";
} 