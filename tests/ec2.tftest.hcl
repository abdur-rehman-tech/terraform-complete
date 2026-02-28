# Terraform test file for EC2 module behaviors using mocked AWS provider

# Use a mocked AWS provider so no real cloud calls are made
mock_provider "aws" {
  source = "hashicorp/aws"
}

# Run a plan and assert on configuration values that are known at plan time
run "plan" {
  command = plan

  # 1) Should create three EC2 instances via for_each with expected keys
  assert {
    condition     = setequals(toset(keys(aws_instance.my_instance)), toset(["TWS-Rehman", "TWS-Rehman2", "TWS-Rehman3"]))
    error_message = "aws_instance.my_instance for_each keys should be exactly the three expected names"
  }

  # 2) Should set instance_type to t2.micro for all instances
  assert {
    condition     = alltrue([for k, v in aws_instance.my_instance : v.instance_type == "t2.micro"]) 
    error_message = "All instances should have instance_type set to t2.micro"
  }

  # 3) Should attach exactly one security group to each instance
  assert {
    condition     = alltrue([for k, v in aws_instance.my_instance : length(v.vpc_security_group_ids) == 1])
    error_message = "Each instance should have exactly one security group attached"
  }

  # 4) Should configure root_block_device with gp3 and the expected size
  assert {
    condition     = alltrue([for k, v in aws_instance.my_instance : v.root_block_device[0].volume_type == "gp3"]) 
    error_message = "Each instance root volume type should be gp3"
  }

  assert {
    condition     = alltrue([for k, v in aws_instance.my_instance : v.root_block_device[0].volume_size == var.ec2_root_storage_size])
    error_message = "Each instance root volume size should equal var.ec2_root_storage_size"
  }

  # 5) Should assign Name tag equal to its for_each key for representative instances
  assert {
    condition     = aws_instance.my_instance["TWS-Rehman"].tags["Name"] == "TWS-Rehman"
    error_message = "Instance TWS-Rehman should have Name tag equal to 'TWS-Rehman'"
  }

  assert {
    condition     = aws_instance.my_instance["TWS-Rehman2"].tags["Name"] == "TWS-Rehman2"
    error_message = "Instance TWS-Rehman2 should have Name tag equal to 'TWS-Rehman2'"
  }

  # 6) Should reference the created key pair and use the expected key name
  assert {
    condition     = aws_instance.my_instance["TWS-Rehman"].key_name == aws_key_pair.Deployer.key_name && aws_key_pair.Deployer.key_name == "TerraKey_EC2"
    error_message = "Instances should reference the created key pair with key_name TerraKey_EC2"
  }

  # 7) Security group should have two ingress rules (22 and 80) and one egress rule
  assert {
    condition     = length(aws_security_group.security_group.ingress) == 2
    error_message = "Security group should have exactly two ingress rules"
  }

  assert {
    condition     = contains([for r in aws_security_group.security_group.ingress : r.from_port], 22)
    error_message = "Security group should allow ingress on TCP 22"
  }

  assert {
    condition     = contains([for r in aws_security_group.security_group.ingress : r.from_port], 80)
    error_message = "Security group should allow ingress on TCP 80"
  }

  assert {
    condition     = length(aws_security_group.security_group.egress) == 1
    error_message = "Security group should have exactly one egress rule"
  }

  # 8) Output object should expose keys for all three instances (values will be unknown at plan time)
  assert {
    condition     = setequals(toset(keys(output.ec2_public_ips)), toset(["TWS-Rehman", "TWS-Rehman2", "TWS-Rehman3"]))
    error_message = "Output ec2_public_ips should contain keys for all three instances"
  }

  # 9) User data should be present (non-empty) for at least one instance as an indicator the file was read
  assert {
    condition     = length(aws_instance.my_instance["TWS-Rehman"].user_data) > 0
    error_message = "User data should be supplied to instances from install_nginx.sh"
  }

  # 10) Security group metadata (name/description) should match expected values
  assert {
    condition     = aws_security_group.security_group.name == "automate-sg"
    error_message = "Security group name should be 'automate-sg'"
  }

  assert {
    condition     = aws_security_group.security_group.description == "This will add a security group"
    error_message = "Security group description should match the expected text"
  }
}
