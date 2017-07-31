require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-1'

# QA VPC and Subnets
aws_vpc "pc-qa-vpc" do
  cidr_block "10.0.0.0/16"
  internet_gateway true
  main_routes '0.0.0.0/0' => :internet_gateway
end

aws_route_table "pc-public" do
  vpc 'pc-qa-vpc'
  routes '0.0.0.0/0' => :internet_gateway
end

aws_route_table "pc-private" do
  vpc 'pc-qa-vpc'
end

aws_subnet "pc-qa-public-subnet-a" do
  vpc "pc-qa-vpc"
  cidr_block "10.0.0.0/24"
  availability_zone "us-east-1a"
  route_table "pc-public"
  map_public_ip_on_launch true
end

aws_subnet "pc-qa-public-subnet-b" do
  vpc "pc-qa-vpc"
  cidr_block "10.0.1.0/24"
  availability_zone "us-east-1b"
  route_table "pc-public"
  map_public_ip_on_launch true
end

aws_subnet "pc-qa-private-subnet-a" do
  vpc "pc-qa-vpc"
  cidr_block "10.0.2.0/24"
  route_table "pc-private"
  availability_zone "us-east-1a"
end

aws_subnet "pc-qa-private-subnet-b" do
  vpc "pc-qa-vpc"
  cidr_block "10.0.3.0/24"
  route_table "pc-private"
  availability_zone "us-east-1b"
end

# Build VPC and Subnets

aws_vpc "pc-build-vpc" do
  cidr_block "192.0.0.0/16"
  internet_gateway true
  main_routes '0.0.0.0/0' => :internet_gateway
end

aws_subnet "pc-jenkins-public-subnet" do
  vpc "pc-build-vpc"
  subnet_id "subnet-3fee8e13"
  cidr_block "192.0.0.0/24"
  availability_zone "us-east-1a"
  map_public_ip_on_launch true
end



