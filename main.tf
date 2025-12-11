 terraform {
  backend "s3" {
    bucket = "vedika-swami"
    key = "jenkins"
    region = "ap-south-1"
  }
}
provider "aws" {
  region = var.region 
}
# create a vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr 
  tags = {
    Name = "${var.project_name}-vpc" # pass the variable inside the string
  }
}
# create a private subnet 
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  cidr_block = var.private_cidr
  availability_zone = var.az2
  tags = {
    Name ="${var.project_name}-private.subnet"
  }
}
# create a public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  cidr_block = var.public_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name ="${var.project_name}-public.subnet"
  }
}
# create internet gateway
resource "aws_internet_gateway" "my-IGW" {
    vpc_id = aws_vpc.my_vpc.id 
    tags = {
      Name = "${var.project_name}-IGW"
    }
}
# create a default RT
resource "aws_default_route_table" "main-RT" {
 default_route_table_id = aws_vpc.my_vpc.default_route_table_id  
 tags = {
   Name = "${var.project_name}-main-RT"
 }
}
# add a route in main route table
resource "aws_route" "aws-route" {
  route_table_id = aws_default_route_table.main-RT.id
  destination_cidr_block = var.igw_cidr
  gateway_id = aws_internet_gateway.my-IGW.id
}
# create a security group
resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my_vpc.id
  name = "${var.project_name}-SG"
  description = "allow ssh, http, mysql traffic"
  ingress  {
    protocol = "tcp"
    to_port = 22
    from_port = 22
    cidr_blocks =["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    to_port = 3306
    from_port = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    protocol = -1
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [ aws_vpc.my_vpc ] #explicite depenency
}
# create a public server
resource "aws_instance" "public-server" {
  subnet_id = aws_subnet.public-subnet.id
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Name = "${var.project_name}-app-server"
  }
  depends_on = [ aws_security_group.my-sg ]
}
# create a private server
resource "aws_instance" "private-server" {
  subnet_id = aws_subnet.private-subnet.id
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Name = "${var.project_name}-db-server"
  }
  depends_on = [ aws_security_group.my-sg ]
}  