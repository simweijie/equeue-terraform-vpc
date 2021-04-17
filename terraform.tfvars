#----------------------------------------------------------------------------
# AWS
#----------------------------------------------------------------------------
aws_region = "us-east-1"

#----------------------------------------------------------------------------
# VPC
#----------------------------------------------------------------------------
vpc_cidr_block = "10.0.0.0/16"

#----------------------------------------------------------------------------
# Public
#----------------------------------------------------------------------------
public_az1_cidr_block = "10.0.0.0/20"
public_az2_cidr_block = "10.0.16.0/20"
public_az3_cidr_block = "10.0.32.0/20"
public_az1_az = "us-east-1a"
public_az2_az = "us-east-1b"
public_az3_az = "us-east-1c"

public_inbound_rules = [
  { rule_num: 100, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "tcp" },      # Internet (Two Way)
  { rule_num: 110, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "udp" }       # Internet (Two Way)
]

public_outbound_rules = [
  { rule_num: 100, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "tcp" },      # Internet (Two Way)
  { rule_num: 110, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "udp" }       # Internet (Two Way)
]

#----------------------------------------------------------------------------
# Logic
#----------------------------------------------------------------------------
logic_az1_cidr_block = "10.0.128.0/20"
logic_az2_cidr_block = "10.0.144.0/20"
logic_az3_cidr_block = "10.0.160.0/20"
logic_az1_az = "us-east-1a"
logic_az2_az = "us-east-1b"
logic_az3_az = "us-east-1c"

logic_inbound_rules = [
  { rule_num: 100, from_port: 53, to_port: 53, cidr: "0.0.0.0/0", protocol: "udp" },        # Back from Internet
  { rule_num: 110, from_port: 80, to_port: 80, cidr: "0.0.0.0/0", protocol: "tcp" },        # Back from Internet
  { rule_num: 120, from_port: 443, to_port: 443, cidr: "0.0.0.0/0", protocol: "tcp" },      # Back from Internet
  { rule_num: 130, from_port: 0, to_port: 65535, cidr: "10.0.128.0/18", protocol: "tcp" },  # Incoming from Own Tier
  { rule_num: 140, from_port: 0, to_port: 65535, cidr: "10.0.0.0/18", protocol: "tcp" },    # Incoming from Public Tier
  { rule_num: 150, from_port: 0, to_port: 65535, cidr: "10.0.192.0/18", protocol: "tcp" }   # Incoming from Data Tier
]

logic_outbound_rules = [
  { rule_num: 100, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "tcp" },      # Out to Internet
  { rule_num: 110, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "udp" }       # Out to Internet
]

#----------------------------------------------------------------------------
# Data
#----------------------------------------------------------------------------
data_az1_cidr_block = "10.0.192.0/20"
data_az2_cidr_block = "10.0.208.0/20"
data_az3_cidr_block = "10.0.224.0/20"
data_az1_az = "us-east-1a"
data_az2_az = "us-east-1b"
data_az3_az = "us-east-1c"

data_inbound_rules = [
  { rule_num: 100, from_port: 53, to_port: 53, cidr: "0.0.0.0/0", protocol: "udp" },        # Back from Internet
  { rule_num: 110, from_port: 80, to_port: 80, cidr: "0.0.0.0/0", protocol: "tcp" },        # Back from Internet
  { rule_num: 120, from_port: 443, to_port: 443, cidr: "0.0.0.0/0", protocol: "tcp" },      # Back from Internet
  { rule_num: 130, from_port: 0, to_port: 65535, cidr: "10.0.192.0/18", protocol: "tcp" },  # Incoming from Own Tier
  { rule_num: 140, from_port: 1024, to_port: 65535, cidr: "10.0.0.0/18", protocol: "tcp" }, # Incoming from Public Tier (For Bastion Host usage)
  { rule_num: 150, from_port: 0, to_port: 65535, cidr: "10.0.128.0/18", protocol: "tcp" }   # Incoming from Logic Tier
]

data_outbound_rules = [
  { rule_num: 100, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "tcp" },      # Out to Internet
  { rule_num: 110, from_port: 0, to_port: 65535, cidr: "0.0.0.0/0", protocol: "udp" }       # Out to Internet
]