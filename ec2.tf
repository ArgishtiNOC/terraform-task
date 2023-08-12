resource "aws_instance" "task_4"{
  
    ami = "ami-0a824feed96a39165"
    instance_type = "t2.micro"
    subnet_id  =  aws_subnet.task4-public-1.id
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    vpc_security_group_ids = [aws_security_group.task4.id]
    associate_public_ip_address = true
    user_data = <<-EOF
    #!/bin/bash
    docker pull public.ecr.aws/z4r1d8r6/task4
    docker run -p 80:3000 public.ecr.aws/z4r1d8r6/task4
    EOF


}

resource "aws_security_group" "task4" {
    name = "task4"
    vpc_id = aws_vpc.task4.id
    dynamic "ingress" {
      for_each = ["22", "80", "3000"]  
      content{
        from_port = ingress.value
        to_port   = ingress.value
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
      }
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

