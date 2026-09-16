variable "AMI_EC2_id" {
    description = "AMI ID para instancia EC2"
      type = string 
      default = "ami-0c55b159cbfafe1f0"
}
variable "EC2_instance_type" {
    description = "type instance EC2"
      type = string 
      default = "t3.micro"
}