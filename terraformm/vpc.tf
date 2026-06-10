resource "aws_vpc" "suman" {                     // this is the default ip
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "suman-vpc"
  }
}

resource "aws_subnet" "main" {                    // this is my ip for public access through igw
  vpc_id     = aws_vpc.suman.id 
   cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-1b"
   map_public_ip_on_launch = true

  tags = {
    Name = "suman-subnet"
  }
}



resource "aws_internet_gateway" "gw" {               // this is the internet gateway so that my public subnet get internet access
  vpc_id = aws_vpc.suman.id

  tags = {
    Name = "suman-igw"
  }
}


resource "aws_route_table" "route_table" {                 // this is the default entry gateway and 
  vpc_id = aws_vpc.suman.id                                 // has access to internet 0.0.0.0/0 means this can go anywhere 

  route {
    cidr_block = "0.0.0.0/0" //default igw entry
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "suman-route-table"
  }
}





resource "aws_route_table_association" "subnet_route-table" {            // my public subnet and igw must be connected
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.route_table.id
}


//for private subnet

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"
# }


# resource "aws_nat_gateway" "nat" {

#   allocation_id = aws_eip.nat_eip.id

#   subnet_id = aws_subnet.main.id

#   depends_on = [
#     aws_internet_gateway.gw
#   ]

#   tags = {
#     Name = "suman-nat"
#   }
# }

# resource "aws_subnet" "private_1" {                 // these are my private ip
#   vpc_id            = aws_vpc.suman.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#   Name = "private-subnet-1"
# }
# }

# resource "aws_subnet" "private_2" {
#   vpc_id            = aws_vpc.suman.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#   Name = "private-subnet-2"
# }
# }

# resource "aws_db_subnet_group" "main" {          // its for my db subnet or RDS
#   name = "main-db-subnet"

#   subnet_ids = [
#     aws_subnet.private_1.id,
#     aws_subnet.private_2.id
#   ]
# }

# resource "aws_route_table" "private_rt" {  //for private route table association but this dosent have internet access
#   vpc_id = aws_vpc.suman.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }


# resource "aws_route_table_association" "private_1_assoc" {    // my private subnet and private route table should be associated
#   subnet_id      = aws_subnet.private_1.id
#   route_table_id = aws_route_table.private_rt.id
# }


# resource "aws_route_table_association" "private_2_assoc" {
#   subnet_id      = aws_subnet.private_2.id
#   route_table_id = aws_route_table.private_rt.id
# }


# resource "aws_db_instance" "postgres" {               //my databse lives inside private subnet

#   identifier = "suman-postgres"

#   allocated_storage = 10

#   engine         = "postgres"
#   engine_version = "17"

#   instance_class = "db.t3.micro"

#   username = "postgres"
#   password = var.db_password

#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]

#   publicly_accessible = false

#   skip_final_snapshot = true
# }



  #                INTERNET
  #                    │
  #                    │
  #            Cloudflare DNS
  #                    │
  #                    │
  #              CloudFront CDN
  #                    │
  #                    │
  #         ┌────────────────────┐
  #         │ Internet Gateway   │
  #         └────────────────────┘
  #                    │
  #                    │
  #         ┌────────────────────┐
  #         │ Public Route Table │
  #         │ 0.0.0.0/0 -> IGW   │
  #         └────────────────────┘
  #                    │
  #                    │
  #         ┌────────────────────┐
  #         │ Public Subnet      │
  #         │ 10.0.1.0/24        │
  #         │                    │
  #         │ EC2 Instance       │
  #         │ NAT Gateway        │
  #         └────────────────────┘
  #                    │
  #        ┌───────────┴────────────┐
  #        │                        │
  #        │                        │
  #        ▼                        ▼

  #  S3 Bucket                 Private Route Table
  #                                 │
  #                        0.0.0.0/0 -> NAT
  #                                 │
  #                       ┌─────────┴─────────┐
  #                       ▼                   ▼

  #              ┌────────────────┐  ┌────────────────┐
  #              │ PrivateSubnet1 │  │ PrivateSubnet2 │
  #              │ 10.0.2.0/24    │  │ 10.0.3.0/24    │
  #              └────────────────┘  └────────────────┘
  #                         \             /
  #                          \           /
  #                           \         /
  #                        ┌────────────────┐
  #                        │ PostgreSQL RDS │
  #                        └────────────────┘