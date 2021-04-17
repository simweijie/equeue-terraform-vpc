#----------------------------------------------------------------------------
# Logic Tier
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Subnets
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "logic_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.logic_az1_cidr_block
  availability_zone = var.logic_az1_az

  tags = {
    Name = "logic_az1"
  }
}

resource "aws_subnet" "logic_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.logic_az2_cidr_block
  availability_zone = var.logic_az2_az

  tags = {
    Name = "logic_az2"
  }
}

resource "aws_subnet" "logic_az3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.logic_az3_cidr_block
  availability_zone = var.logic_az3_az

  tags = {
    Name = "logic_az3"
  }
}

#----------------------------------------------------------------------------
# Route Tables
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
# https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithRouteTables.html
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# 3 separate RTs allow for each zone to connect to a different NAT Gateway for a total of 3 NAT Gateways
# For proof of concept 1 NAT Gateway is used
resource "aws_route_table" "logic_az1_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Logic AZ1 Route Table"
  }
}

resource "aws_route_table" "logic_az2_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Logic AZ2 Route Table"
  }
}

resource "aws_route_table" "logic_az3_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Logic AZ3 Route Table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "logic_az1_rt_logic_az1" {
  subnet_id      = aws_subnet.logic_az1.id
  route_table_id = aws_route_table.logic_az1_rt.id
}

resource "aws_route_table_association" "logic_az2_rt_logic_az2" {
  subnet_id      = aws_subnet.logic_az2.id
  route_table_id = aws_route_table.logic_az2_rt.id
}

resource "aws_route_table_association" "logic_az2_rt_logic_az3" {
  subnet_id      = aws_subnet.logic_az3.id
  route_table_id = aws_route_table.logic_az3_rt.id
}

#----------------------------------------------------------------------------
# NACL
#----------------------------------------------------------------------------
resource "aws_network_acl" "logic_nacl" { 
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.logic_az1.id, aws_subnet.logic_az2.id, aws_subnet.logic_az3.id]

  tags = {
    Name = "Logic NACL"
  }
}

# https://stackoverflow.com/questions/62799006/terraform-aws-creating-private-acl-dynamically-with-looping-logics
# https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12
resource "aws_network_acl_rule" "logic_ingress" {
  for_each = {for logic_inbound_rule in var.logic_inbound_rules: logic_inbound_rule.rule_num => logic_inbound_rule}

  network_acl_id = aws_network_acl.logic_nacl.id
  egress = false
  rule_action = "allow"

  rule_number = each.value.rule_num
  cidr_block = each.value.cidr
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
}

resource "aws_network_acl_rule" "logic_egress" {
  for_each = {for logic_outbound_rule in var.logic_outbound_rules: logic_outbound_rule.rule_num => logic_outbound_rule}

  network_acl_id = aws_network_acl.logic_nacl.id
  egress = true
  rule_action = "allow"

  rule_number = each.value.rule_num
  cidr_block = each.value.cidr
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
}