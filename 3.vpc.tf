# first step --- vpc creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

# second step ---- subnte creation
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
  map_public_ip_on_launch = "true"
}

# 3rd step --- internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}






# step 4 --- creation of route table and connection it with internet gateway 

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "example"
  }
}


## step 5 --- route table asscocaution (connecting route table with subnet ) 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.example.id
}

### step 6 --- craeting security group within custom vpc

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.main.id
  # ... other configuration ...
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}



#### step 7 creating ec2 resorce 


resource "aws_instance" "web" {

  ami           = var.ami-id
  instance_type = var.istance-type

  tags = {
    Name = "HelloWorld"
  }

  
  vpc_security_group_ids = ["${aws_security_group.example.id }"]
  subnet_id              = "${aws_subnet.subnet.id}"
}
