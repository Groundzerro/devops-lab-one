# infra/main.tf

locals {
  common_tags = {
    Project = var.project_name
    Owner   = "devops-lab"
  }
}

# --- Network module (VPC, subnet, IGW, route tables) ---

module "network" {
  source             = "./modules/network"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  project_name       = var.project_name
}

# --- Security groups ---

# SSH from your IP only
module "sg_ssh" {
  source        = "./modules/security-group"
  name          = "${var.project_name}-sg-ssh"
  vpc_id        = module.network.vpc_id
  ingress_cidrs = [var.my_ip_cidr]
  ingress_ports = [22]
  tags          = local.common_tags
}

# HTTP (80) from everywhere (for testing web UI)
module "sg_http" {
  source        = "./modules/security-group"
  name          = "${var.project_name}-sg-http"
  vpc_id        = module.network.vpc_id
  ingress_cidrs = ["0.0.0.0/0"]
  ingress_ports = [80]
  tags          = local.common_tags
}

# Jenkins UI port 8080 from your IP (for now)
module "sg_jenkins" {
  source        = "./modules/security-group"
  name          = "${var.project_name}-sg-jenkins"
  vpc_id        = module.network.vpc_id
  ingress_cidrs = [var.my_ip_cidr]
  ingress_ports = [8080]
  tags          = local.common_tags
}

# --- EC2 Instances ---

# Jenkins Master
module "jenkins_master" {
  source        = "./modules/ec2-instance"
  name          = "jenkins-master"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
    module.sg_jenkins.security_group_id,
  ]
  private_ip = "10.0.1.10"

  user_data = file("${path.module}/../scripts/jenkins-master-init.sh")

  tags = merge(local.common_tags, {
    Role = "jenkins-master"
  })
}

# Tomcat Server
module "tomcat" {
  source        = "./modules/ec2-instance"
  name          = "tomcat"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
    module.sg_http.security_group_id,
  ]
  private_ip = "10.0.1.11"

  user_data = file("${path.module}/../scripts/tomcat-init.sh")

  tags = merge(local.common_tags, {
    Role = "tomcat"
  })
}

# =======================
# SONARQUBE SERVER
# =======================
module "sonarqube" {
  source        = "./modules/ec2-instance"
  name          = "sonarqube"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
    module.sg_http.security_group_id, # Expose port 9000 if needed
  ]
  private_ip = "10.0.1.12"
  user_data  = file("${path.module}/../scripts/sonar-init.sh")

  tags = merge(local.common_tags, {
    Role = "SonarQube"
  })
}

# =======================
# NEXUS SERVER
# =======================
module "nexus" {
  source        = "./modules/ec2-instance"
  name          = "nexus"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
    module.sg_http.security_group_id, # Expose port 8081
  ]
  private_ip = "10.0.1.13"
  user_data  = file("${path.module}/../scripts/nexus-init.sh")

  tags = merge(local.common_tags, {
    Role = "Nexus"
  })
}

# =======================
# MAVEN BUILDER SERVER
# =======================
module "maven" {
  source        = "./modules/ec2-instance"
  name          = "maven-builder"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
  ]
  private_ip = "10.0.1.14"
  user_data  = file("${path.module}/../scripts/maven-init.sh")

  tags = merge(local.common_tags, {
    Role = "Maven-Build"
  })
}

# =======================
# JENKINS AGENT EXECUTOR
# =======================
module "jenkins_agent" {
  source        = "./modules/ec2-instance"
  name          = "jenkins-agent"
  ami_id        = var.base_ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  key_name      = var.key_name
  security_group_ids = [
    module.sg_ssh.security_group_id,
  ]
  private_ip = "10.0.1.15"
  user_data  = file("${path.module}/../scripts/jenkins-agent-init.sh")

  tags = merge(local.common_tags, {
    Role = "Jenkins-Agent"
  })
}



# Example stubs in infra/main.tf (later)

# module "sonarqube" {
#   source             = "./modules/ec2-instance"
#   name               = "sonarqube"
#   ami_id             = var.base_ami_id
#   instance_type      = var.instance_type
#   subnet_id          = module.network.public_subnet_id
#   key_name           = var.key_name
#   security_group_ids = [
#     module.sg_ssh.security_group_id,
#     # plus an SG that allows 9000 if you want direct access
#   ]
#   private_ip         = "10.0.1.12"
#   user_data          = file("${path.module}/../scripts/sonar-init.sh")
#   tags               = merge(local.common_tags, { Role = "sonarqube" })
# }

# module "nexus" {
#   source             = "./modules/ec2-instance"
#   name               = "nexus"
#   ami_id             = var.base_ami_id
#   instance_type      = var.instance_type
#   subnet_id          = module.network.public_subnet_id
#   key_name           = var.key_name
#   security_group_ids = [
#     module.sg_ssh.security_group_id,
#     # plus an SG that allows 8081 if you want direct access
#   ]
#   private_ip         = "10.0.1.13"
#   user_data          = file("${path.module}/../scripts/nexus-init.sh")
#   tags               = merge(local.common_tags, { Role = "nexus" })
# }

