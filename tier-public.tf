#----------------------------------------------------------------------------
# Public Tier
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Subnets
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_az1_cidr_block
  availability_zone = var.public_az1_az

  tags = {
    Name = "public_az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_az2_cidr_block
  availability_zone = var.public_az2_az

  tags = {
    Name = "public_az2"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_az3_cidr_block
  availability_zone = var.public_az3_az

  tags = {
    Name = "public_az3"
  }
}

#----------------------------------------------------------------------------
# Route Table(s)?
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
# https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithRouteTables.html
#----------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public Route Table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "rt_internet" {
  route_table_id  = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.gw.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public_rt_public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_public_az3" {
  subnet_id      = aws_subnet.public_az3.id
  route_table_id = aws_route_table.public_rt.id
}

# attach internet gateway to public tier route table
# Already attaches to RT table by default (why and how? because of Nat GW's existence?)
# resource "aws_route_table_association" "public_rt_igw" {
#   gateway_id     = aws_internet_gateway.gw.id
#   route_table_id = aws_route_table.public_rt.id
# }

#----------------------------------------------------------------------------
# NACL
#----------------------------------------------------------------------------
resource "aws_network_acl" "public_nacl" { 
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]

  tags = {
    Name = "Public NACL"
  }
}

# https://stackoverflow.com/questions/62799006/terraform-aws-creating-private-acl-dynamically-with-looping-logics
# https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12
resource "aws_network_acl_rule" "public_ingress" {
  for_each = {for public_inbound_rule in var.public_inbound_rules: public_inbound_rule.rule_num => public_inbound_rule}

  network_acl_id = aws_network_acl.public_nacl.id
  egress = false
  rule_action = "allow"

  rule_number = each.value.rule_num
  cidr_block = each.value.cidr
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
}

resource "aws_network_acl_rule" "public_egress" {
  for_each = {for public_outbound_rule in var.public_outbound_rules: public_outbound_rule.rule_num => public_outbound_rule}

  network_acl_id = aws_network_acl.public_nacl.id
  egress = true
  rule_action = "allow"

  rule_number = each.value.rule_num
  cidr_block = each.value.cidr
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
}