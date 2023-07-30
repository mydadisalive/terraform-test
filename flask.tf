resource "aws_instance" "flask_instance" {
  ami           = "ami-0f34c5ae932e6f0e4"  # Replace with the AMI ID of Amazon Linux 2
  instance_type = "t3.micro"
  key_name      = aws_key_pair.my_keypair.key_name
  tags = {
    Name = "FlaskInstance"
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"  # Use "ec2-user" for Amazon Linux 2
    private_key = file("my-keypair")  # Replace with the path to your private key file
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",               # Update packages
      "sudo yum install -y python3",      # Install Python3 (Python 3.7 on Amazon Linux 2)
      "sudo yum install -y python3-pip",  # Install pip for Python3
      "sudo pip3 install flask"           # Install Flask framework
    ]
  }

  provisioner "file" {
    source      = "app.py"  # Path to your Flask app file (app.py)
    destination = "/home/ec2-user/app.py"  # Destination path on the instance
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ec2-user",
      "nohup python3 app.py &"  # Run the Flask app in the background using nohup
    ]
  }
}
