# AWS Web Server Deployment with VPC, EC2, Nginx and Security Best Practices

## Project Overview

This project demonstrates how to deploy a secure cloud-based web server on AWS using a custom VPC, public subnet, route table, Internet Gateway, EC2 instance, security group, SSH, Linux administration, and Nginx.

The goal of the project is to host a custom webpage on an EC2 instance while following basic AWS networking and security best practices.

## Project Scenario

I was tasked as a Junior Cloud Engineer to deploy a company's website on AWS. The web server needed to be accessible from the internet while being placed inside a properly configured AWS network environment.

## Project Objectives

The project demonstrates practical knowledge of:

- AWS VPC
- CIDR blocks and subnets
- Route tables
- Internet Gateway
- Security groups
- EC2
- SSH
- Linux administration
- Nginx
- Public IP addressing
- IAM
- Basic troubleshooting
- Cloud architecture documentation

## Architecture Diagram

The architecture includes the following components:

- Internet Users
- AWS Cloud
- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- Nginx Web Server


## Architecture Explanation

The infrastructure was designed inside an AWS Cloud environment. A custom VPC was created with the CIDR block `10.0.0.0/16`. Inside the VPC, a public subnet was planned using the CIDR block `10.0.1.0/24`.

An Internet Gateway allows internet connectivity for resources inside the VPC. A route table directs internet-bound traffic through the Internet Gateway. The EC2 instance is placed inside the public subnet and protected by a security group. The security group allows HTTP traffic from the internet and restricts SSH access to my own IP address.

Nginx is installed on the EC2 instance to serve a custom webpage.

---

## Stage 1: Project Understanding

Before creating AWS resources, I reviewed the project requirements and identified the main services needed for the deployment.

The required cloud components are:

- VPC
- Public subnet
- Internet Gateway
- Route table
- Security group
- EC2 instance
- Nginx web server

The expected final deliverables are:

- Architecture diagram
- Screenshots of AWS resources
- Public website URL or public IP address
- Project documentation
- Troubleshooting report
- Optional bash deployment script

---

## Stage 2: Architecture Design

I created an architecture diagram showing how users from the internet will access the web server hosted on AWS.

The diagram shows an internet user accessing the EC2 instance through the public IP address. The traffic enters the AWS environment through the Internet Gateway and reaches the EC2 instance in the public subnet. The security group controls which traffic is allowed to reach the instance.

### Screenshot

![Architecture Diagram](screenshots/01-architecture-diagram.png)

### What I Learned

I learned that a public EC2 web server requires more than just launching an instance. The network must include a VPC, a public subnet, an Internet Gateway, a route table with a public route, and a security group that allows the required traffic.

---

## Stage 3: Create a Custom VPC

### Purpose

The VPC acts as the private network boundary for the AWS resources in this project.

I created a custom VPC instead of using the default VPC because the project required me to demonstrate manual cloud networking setup.

### VPC Configuration

| Setting | Value |
|---|---|
| VPC Name | `cloud-webserver-vpc` |
| IPv4 CIDR Block | `10.0.0.0/16` |
| IPv6 CIDR Block | No IPv6 CIDR block |
| Tenancy | Default |

### Steps Taken

1. I logged in to the AWS Management Console.
2. I searched for `VPC` in the AWS search bar.
3. I opened the VPC dashboard.
4. I clicked `Your VPCs`.
5. I clicked `Create VPC`.
6. I selected `VPC only`.
7. I entered the name `cloud-webserver-vpc`.
8. I entered the IPv4 CIDR block `10.0.0.0/16`.
9. I left IPv6 disabled.
10. I kept tenancy as `Default`.
11. I clicked `Create VPC`.

### Screenshot

![Custom VPC Created](screenshots/02-vpc-created.png)

### Explanation

The custom VPC provides an isolated AWS network where the public subnet, route table, Internet Gateway, security group, and EC2 instance will be configured.

The CIDR block `10.0.0.0/16` gives the VPC enough private IP addresses for future subnet expansion.

### What I Learned

I learned that a VPC is the foundation of AWS networking. It does not automatically provide internet access. Internet access requires additional components such as an Internet Gateway and a route table.

---

## Stage 4: Create a Public Subnet

### Purpose

A subnet is a smaller network created inside a VPC. I created a public subnet to host the EC2 instance that will run the Nginx web server.

The subnet uses the CIDR block `10.0.1.0/24`, which is part of the larger VPC CIDR block `10.0.0.0/16`.

### Subnet Configuration

| Setting | Value |
|---|---|
| Subnet Name | `cloud-webserver-public-subnet` |
| VPC | `cloud-webserver-vpc` |
| VPC CIDR Block | `10.0.0.0/16` |
| Subnet CIDR Block | `10.0.1.0/24` |
| Availability Zone | `eu-north-1a` |

### Steps Taken

1. I opened the AWS Management Console.
2. I searched for `VPC` and opened the VPC dashboard.
3. I clicked `Subnets` from the left navigation menu.
4. I clicked `Create subnet`.
5. I selected my custom VPC named `cloud-webserver-vpc`.
6. I entered the subnet name `cloud-webserver-public-subnet`.
7. I selected an Availability Zone.
8. I entered the IPv4 subnet CIDR block `10.0.1.0/24`.
9. I clicked `Create subnet`.

### Screenshot

![Public Subnet Created](screenshots/03-public-subnet-created.png)

### Explanation

The public subnet is where the EC2 instance will be launched. At this point, the subnet has been created, but it is not fully public yet. For the subnet to become public, it must be associated with a route table that has a route to an Internet Gateway.

### What I Learned

I learned that a subnet is a smaller IP range inside a VPC. I also learned that a subnet is not automatically public just because it is named public. It becomes public only when its route table sends internet-bound traffic to an Internet Gateway.

---

## Stage 5: Create and Attach an Internet Gateway

### Purpose

An Internet Gateway allows communication between a VPC and the internet.

I created an Internet Gateway so that resources inside my VPC can later become publicly accessible when the correct route table configuration is added.

### Internet Gateway Configuration

| Setting | Value |
|---|---|
| Internet Gateway Name | `cloud-webserver-igw` |
| Attached VPC | `cloud-webserver-vpc` |
| VPC CIDR Block | `10.0.0.0/16` |
| State | `Attached` |

### Steps Taken

1. I opened the AWS Management Console.
2. I searched for `VPC` and opened the VPC dashboard.
3. From the left navigation menu, I clicked `Internet gateways`.
4. I clicked `Create internet gateway`.
5. I entered the name `cloud-webserver-igw`.
6. I clicked `Create internet gateway`.
7. After the Internet Gateway was created, I clicked `Actions`.
8. I selected `Attach to VPC`.
9. I selected my custom VPC named `cloud-webserver-vpc`.
10. I clicked `Attach internet gateway`.

### Screenshot

![Internet Gateway Attached](screenshots/04-internet-gateway-attached.png)

### Explanation

The Internet Gateway acts as the connection point between the VPC and the public internet.

At this stage, the gateway has been created and attached to the VPC, but the subnet is not fully public yet. A route table still needs to be configured with a default route that sends internet-bound traffic to the Internet Gateway.

### What I Learned

I learned that attaching an Internet Gateway to a VPC does not automatically make resources public. A route table must also contain a route such as `0.0.0.0/0` pointing to the Internet Gateway.

---

## Stage 6: Configure the Route Table and Subnet Association

### Purpose

A route table controls where network traffic is directed inside a VPC.

I created a custom route table for the public subnet and added a default route that sends internet-bound traffic to the Internet Gateway.

### Route Table Configuration

| Setting | Value |
|---|---|
| Route Table Name | `cloud-webserver-public-rt` |
| VPC | `cloud-webserver-vpc` |
| Public Subnet | `cloud-webserver-public-subnet` |
| Internet Gateway | `cloud-webserver-igw` |
| Public Route | `0.0.0.0/0 -> Internet Gateway` |

### Steps Taken

1. I opened the AWS Management Console.
2. I searched for `VPC` and opened the VPC dashboard.
3. From the left navigation menu, I clicked `Route tables`.
4. I clicked `Create route table`.
5. I entered the name `cloud-webserver-public-rt`.
6. I selected my custom VPC named `cloud-webserver-vpc`.
7. I clicked `Create route table`.
8. I selected the newly created route table.
9. I clicked the `Routes` tab.
10. I clicked `Edit routes`.
11. I clicked `Add route`.
12. I entered the destination `0.0.0.0/0`.
13. For the target, I selected the Internet Gateway named `cloud-webserver-igw`.
14. I clicked `Save changes`.
15. I clicked the `Subnet associations` tab.
16. I clicked `Edit subnet associations`.
17. I selected the public subnet named `cloud-webserver-public-subnet`.
18. I clicked `Save associations`.

### Screenshot

![Route Table Configured](screenshots/05-route-table-configured.png)

### Explanation

The route table contains a default route, `0.0.0.0/0`, that points to the Internet Gateway.

This route allows resources in the associated public subnet to send traffic to the internet. The subnet became public because it is associated with a route table that has a route to the Internet Gateway.

### What I Learned

I learned that a subnet is not public just because it has the word "public" in its name. A subnet becomes public when it is associated with a route table that has a default route to an Internet Gateway.

---

## Stage 7: Launch an EC2 Instance Inside the Public Subnet

### Purpose

The EC2 instance acts as the virtual server that will run the Nginx web server.

I launched the instance inside the public subnet so that it can be accessed from the internet through its public IPv4 address.

### EC2 Configuration

| Setting | Value |
|---|---|
| Instance Name | `cloud-webserver-ec2` |
| AMI | `Ubuntu Server` |
| Instance Type | `t3.micro` |
| VPC | `cloud-webserver-vpc` |
| Subnet | `cloud-webserver-public-subnet` |
| Auto-assign Public IP | `Enabled` |
| Key Pair | `cloud-webserver-key` |
| Security Group | `cloud-webserver-sg` |

### Steps Taken

1. I opened the AWS Management Console.
2. I searched for `EC2` and opened the EC2 dashboard.
3. I clicked `Instances`.
4. I clicked `Launch instances`.
5. I entered the instance name `cloud-webserver-ec2`.
6. I selected an Ubuntu Server AMI.
7. I selected a free-tier instance type `t3.micro`.
8. I created a key pair for SSH access.
9. Under network settings, I selected my custom VPC named `cloud-webserver-vpc`.
10. I selected the public subnet named `cloud-webserver-public-subnet`.
11. I enabled auto-assign public IP.
12. I created a security group named `cloud-webserver-sg`.
13. I reviewed the configuration and clicked `Launch instance`.
14. I waited until the instance state showed `Running`.
15. I confirmed that the instance had a public IPv4 address.

### Screenshot: EC2 Instance Running

![EC2 Instance Running](screenshots/06-ec2-running.png)

### Explanation

The EC2 instance was launched inside the public subnet of the custom VPC. Because auto-assign public IP was enabled, AWS assigned a public IPv4 address to the instance.

This public IP address will be used to access the Nginx webpage from a browser after the web server is installed and configured.

### What I Learned

I learned that launching an EC2 instance requires selecting the correct VPC and subnet. I also learned that an instance in a public subnet must have a public IP address before it can be accessed directly from the internet.

---

## Stage 8: Configure and Review Security Group Rules

### Purpose

A security group acts as a virtual firewall for an EC2 instance. It controls which inbound and outbound traffic is allowed.

For this project, I configured the security group to allow web traffic while restricting SSH access to my own IP address.

### Security Group Configuration

| Type | Protocol | Port | Source | Purpose |
|---|---|---:|---|---|
| SSH | TCP | `22` | `My IP` | Allows secure terminal access to the EC2 instance |
| HTTP | TCP | `80` | `0.0.0.0/0` | Allows users on the internet to access the website |
| HTTPS | TCP | `443` | `0.0.0.0/0` | Allows secure web traffic if SSL/TLS is configured later |

### Steps Taken

1. I opened the AWS Management Console.
2. I searched for `EC2` and opened the EC2 dashboard.
3. I clicked `Security Groups` from the left navigation menu.
4. I selected the security group attached to my EC2 instance.
5. I reviewed the inbound rules.
6. I confirmed that SSH on port `22` was restricted to my own IP address.
7. I confirmed that HTTP on port `80` was open to users on the internet.
8. I confirmed that HTTPS on port `443` was added for secure web traffic readiness.
9. I avoided opening unnecessary ports.

### Screenshot: Security Group Rules

![Security Group Rules](screenshots/07-security-group-rules.png)

### Explanation

The security group protects the EC2 instance by controlling allowed inbound traffic.

SSH access is restricted to my own IP address to reduce the risk of unauthorized login attempts. HTTP is open to the internet because users need to access the hosted website through a browser. HTTPS is also included as a best-practice web port, even though SSL/TLS may be configured later.

### What I Learned

I learned that security groups are important for controlling access to cloud resources. Instead of opening all ports to everyone, I should allow only the ports required for the application to work.

### Security Best Practice Applied

The most important security decision in this stage was restricting SSH access.

Instead of allowing SSH from anywhere:

```text
0.0.0.0/0
```
I restricted SSH to:
```text
My IP
```
This follows the principle of least privilege because only my current IP address can attempt to connect to the instance through SSH.
