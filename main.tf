# main.tf

provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0f34c5ae932e6f0e4"  # Replace with the desired AMI ID
  instance_type = "t3.micro"              # Replace with the desired instance type
  key_name      = "my-keypair"           # Replace with the name of your SSH keypair (if required)
  tags = {
    Name = "NginxInstance"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate user for your AMI (ubuntu is common for Ubuntu-based AMIs)
    private_key = file("my-keypair")  # Replace with the path to your private key file
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum  install -y nginx",
      "sudo systemctl start nginx",     
      "sudo systemctl enable nginx"           ]
  }

}

resource "aws_key_pair" "my_keypair" {
  key_name   = "my-keypair"  # Replace with the desired name for your key pair
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0f8os/dzQpoNED1m7drkQ4cDlLK+aLju0rXqzp9UymSmRlu5+MCVvK3kQQz+nSTdXz7l0z2WdFFsDtXioK4uZola22HCuWEAril1ZYJvoe2+bfE+dobGVQduquKrSW+bH0hSeZ6gztTlbMPEka66m2KV4UGZ6U/uQjImKI5V9yVWhazDPsl0w8rBERj4b5omzsjHHrLmEPpL+sgF4iC59EJajKsAMEnlIYynDi7v5OmxRbVR4+6X9IfMYS3EByMmtUDAJlhlynN6QuT/ZeCsVfX2FYjqpyzHVFfk7dnrkGzLFh0bFfg3jcHcSlthNYB2yfbQeMrP+hzV8JONR1rIctbAmFI+42Y2Pximm8F3+8KdSQ+X8kLLFY9ICSkjDHVf/rVU+bfg1qb3L75x3uNQBdk+EmcCXBZTR/qaAhVuTDtC0zqzhLuR78kuLqw3A+cokVRuFXp/gyx7jl77wawNjfRq9L1n1KDxfAZm/Zs0wWoCvU5S7oP52s5pEO2VfMJM= user@DESKTOP-L4VENM4"  # Replace with your actual public key content
}

