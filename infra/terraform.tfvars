# infra/terraform.tfvars

aws_region   = "us-west-2"
project_name = "devops-lab"

# Your home/office IP to allow SSH (use https://ifconfig.me or similar)
my_ip_cidr = "23.119.207.114/32"

# EC2 Key Pair name (must exist in AWS already)
key_name = "my-aws-keypair"

# Ubuntu 24.04 LTS (HVM), SSD Volume Type AMI ID for your region (example for us-west-2; look it up in AWS console)
base_ami_id = "ami-00f46ccd1cbfb363e"

instance_type = "t3.small"

