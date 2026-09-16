# Criando VPC
resource "aws_vpc" "First_VPC" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
   Name = "First_VPC" 
 }
}

# Criando uma subnet
 resource "aws_subnet" "Subnet_Public" {
    vpc_id = aws_vpc.First_VPC.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true # Distribui automaticamente Endereço IP público para EC2
     
     tags = {
      Name = "Subnet_Public"
  }
 }

# Criando um Internet Gateway 
resource "aws_internet_gateway" "First_IGW" {
  vpc_id = aws_vpc.First_VPC.id

   tags = { 
     Name = "First_IGW"
  }
 } 

# Criando uma tabela de rotas
resource "aws_route_table" "Route_Table_public" {
  vpc_id = aws_vpc.First_VPC.id

    tags = {
      Name = "Route_Table_public"
    }
  }

# Criando uma rota para IGW
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.Route_Table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.First_IGW.id
}

# Associando a route table a subnet 
resource "aws_route_table_association" "First_Route_Table_Association" {
  subnet_id = aws_subnet.Subnet_Public.id
  route_table_id = aws_route_table.Route_Table_public.id
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"
  description = "Security_Group para instancia web"

  # associando o SG para a vpc 
  vpc_id = aws_vpc.First_VPC.id

  ingress {
    description = "Acesso HTTP"
    from_port = 80
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Resposta liberada para qualquer destino"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "web_sg"
  }
}

# AMI e instance_type para EC2
resource "aws_instance" "web" {
  ami = var.AMI_EC2_id
  instance_type = var.EC2_instance_type

  # Associando na Subnet
  subnet_id = aws_subnet.Subnet_Public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
}