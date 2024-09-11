resource "aws_instance" "test-server" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  key_name = "key-ohio"
  vpc_security_group_ids = ["sg-028931dee6e65b738"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./key-ohio.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/FinanceMe/terraform-files/ansibleplaybook.yml"
     }
  }
