# # ----------------------------------------------------------------------------
# # Nat Gateway
# # ----------------------------------------------------------------------------
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# # For Nat Gateway to use
# # WARNING: Remove if Nat Gateway is deleted or ongoing $0.005/hr charge will be incurred
# # https://aws.amazon.com/ec2/pricing/on-demand/#Elastic_IP_Addresses
 resource "aws_eip" "nat" {
   vpc      = true
 }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# # WARNING: has ongoing hourly charge of $0.045/hr
# # https://aws.amazon.com/vpc/pricing/
 resource "aws_nat_gateway" "gw" {
   allocation_id = aws_eip.nat.id
   subnet_id     = aws_subnet.public_az1.id # Place Nat Gateway in public az 1

   tags = {
     Name = "gw NAT"
   }

   depends_on = [aws_internet_gateway.gw]
 }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
 resource "aws_route" "logic_az1_rt_nat" {
  route_table_id  = aws_route_table.logic_az1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}

resource "aws_route" "logic_az2_rt_nat" {
  route_table_id  = aws_route_table.logic_az2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}

resource "aws_route" "logic_az3_rt_nat" {
  route_table_id  = aws_route_table.logic_az3_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "data_az1_rt_nat" {
  route_table_id  = aws_route_table.data_az1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}

resource "aws_route" "data_az2_rt_nat" {
  route_table_id  = aws_route_table.data_az2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}

resource "aws_route" "data_az3_rt_nat" {
  route_table_id  = aws_route_table.data_az3_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.gw.id # if more than 1 NAT created, point to the different NAT gws
}