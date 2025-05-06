resource "aws_instance" "web_server" {
  count             = (local.env == "test" || local.env == "qa") ? 2 : 3 #if its test or qa it will create 2 instances else it will create 3 instances 
  ami               = lookup(var.ami, var.region) #this will take the ami id from the variable file based on the region
  instance_type     = var.instance_type
  subnet_id         = element(aws_subnet.public-subnets.*.id, count.index) #this will create the instances in the public subnets
  vpc_security_group_ids = [aws_security_group.allow_all_sg.id] #this will attach the security group to the instances
  key_name          = var.key_name #this will attach the key pair to the instances
  associate_public_ip_address = true
  tags = {
    Name = "${local.vpc_name}-web-server-${count.index + 1}"
    Env  = local.env
    Owner = "Terraform"
    Project = "Web Server"
  }

    user_data = <<-EOF
            #!/bin/bash
            sudo dnf update -y
            sudo dnf install -y nginx
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "<h1>${local.vpc_name}-Public-Server-${count.index + 1}</h1>" > /usr/share/nginx/html/index.html
            EOF


  lifecycle {
    create_before_destroy = true #this will create the new instance before destroying the old one
  }
}   