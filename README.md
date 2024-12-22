# AWS VPC Configuration for Provider and Consumer EC2 Instances

This project  AWS infrastructure to connect two EC2 instances, one in a **Provider VPC** and another in a **Consumer VPC**, using a private link for secure communication. The infrastructure also includes a bastion host for accessing the consumer EC2 instance in a private subnet.

## **Infrastructure Components**

### **VPCs**
- **Provider VPC**
 
- **Consumer VPC**


### **Internet Gateway**
- Attached to the Consumer VPC (Bastion Host) for internet access via the public subnet.

### **Route Tables**
- **Provider VPC**: Routes traffic between private subnets and the private link.
- **Consumer VPC**:
  - Public Subnet Route Table: Routes internet traffic through the Internet Gateway.
  - Private Subnet Route Table: Routes traffic to the Provider VPC via the private link.

### **Security Groups**
- **Provider Instance SG**:
  - Allows inbound traffic from the Network Load Balancer (NLB) on ports 22 and 80.

- **Consumer Instance SG**:
  - Allows inbound SSH traffic from the bastion host.

- **Bastion Host SG**:
  - Allows inbound SSH traffic from a specific IP (e.g., your local machine).

- **NLB SG**:
  - Allows inbound traffic from the Consumer VPC's CIDR block.

### **Network Load Balancer (NLB)**
- Deployed in the Provider VPC.
- Routes traffic to the Provider EC2 instance using:
  - Target Group for HTTP (port 80).
  - Target Group for SSH (port 22).

### **Private Link**
- Connects the Consumer VPC to the Provider VPC securely.
- Uses an Interface VPC Endpoint in the Consumer VPC.

### **EC2 Instances**
- **Provider Instance**:
  - Runs Nginx and is accessible via the private link.
  - Located in a private subnet in the Provider VPC.

- **Consumer Instance**:
  - Located in a private subnet in the Consumer VPC.
  - Connects to the Provider instance through the private link.

- **Bastion Host**:
  - Located in the public subnet of the Consumer VPC.
  - Provides SSH access to the Consumer instance.

## **File Structure**

### **1. VPC Configuration**
- `vpc_service_provider.tf`: Defines the Provider VPC, subnets, and route tables.
- `vpc_service_consumer.tf`: Defines the Consumer VPC, subnets, internet gateway, and route tables.

### **2. Security Groups**
- `security_groups.tf`: Configures security groups for the Provider instance, Consumer instance, NLB, and bastion host.

### **3. Network Load Balancer**
- `network_load_balancer.tf`: Creates the NLB and its target groups and listeners.

### **4. EC2 Instances**
- `ec2_instances.tf`: Provisions EC2 instances (Provider, Consumer, and Bastion Host).

### **5. Private Link**
- `endpoint_provider.tf`: Defines the VPC Endpoint Service in the Provider VPC.
- `endpoint_consumer.tf`: Creates the VPC Endpoint in the Consumer VPC.

### **6. Variables**
- `variables.tf`: Defines configurable variables such as CIDR blocks, instance types, and AMIs.

### **7. Outputs**
- `outputs.tf`: Outputs key resources like instance IPs and endpoint DNS names.

## **Deployment Instructions**

1. **Set Up AWS Credentials**
   - Ensure you have AWS credentials configured in your environment.

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan the Deployment**
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**
   ```bash
   terraform apply
   ```

5. **Access Resources**
   - SSH into the bastion host using its public IP.
   - From the bastion host, SSH into the Consumer instance.
   - Use the private link to connect to the Provider instance from the Consumer instance.

## **Testing the Setup**
- Verify that the NLB health checks pass.
- Test HTTP access to the Provider instance from the Consumer instance.
- Ensure SSH access works as expected via the bastion host.

From bastion host:
```bash
 curl vpce-0ee2c7cad1409b684-g1qg708r.vpce-svc-08ce4d7b607cf1279.us-west-2.vpce.amazonaws.com
```
Result:
Hello, World!

