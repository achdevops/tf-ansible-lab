data "aws_eip" "foo" {
  filter {
    name   = "tag:Name"
    values = ["cloudlabs-dev-foo-eip"]
  }
}

data "aws_instance" "foo" {
  filter {
    name   = "tag:Name"
    values = ["cloudlabs-dev-foo"]
  } 
}

data "aws_instance" "bar" {
  filter {
    name   = "tag:Name"
    values = ["cloudlabs-dev-bar"]
  } 
}


# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  
  content = templatefile("${path.module}/inventory.tpl", {
    foo_public_ip  = data.aws_eip.foo.public_ip
    foo_private_ip = data.aws_instance.foo.private_ip
    bar_private_ip = data.aws_instance.bar.private_ip 
  })
  
  filename = "${path.module}/../ansible-playbook/inventory"
}
