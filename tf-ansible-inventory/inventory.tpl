[web_servers]
foo ansible_host=${foo_public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa

[internal_servers]
bar ansible_host=${bar_private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -i ~/.ssh/id_rsa ec2-user@${foo_public_ip}"'

[all:vars]
ansible_python_interpreter=/usr/bin/python3
