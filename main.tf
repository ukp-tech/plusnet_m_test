resource "aws_security_group" "Plusnet-Test-SG" {
    name = "Plusnet-Test-SG"
    description = "SG for development environment"
    vpc_id = "vpc-c97bbda2"
    ingress {
        from_port = 42
        to_port = 42
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        from_port = 9095
        to_port = 9095
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port = 0
    to_port = 0 
    protocol = -1 
    cidr_blocks = ["0.0.0.0/0"]     
    }

}
resource "aws_instance" "Plusnet-Test" {
    ami = "ami-010aff33ed5991201"
    instance_type = "t2.micro"
    disable_api_termination = "true"
    vpc_security_group_ids = [aws_security_group.Plusnet-Test-SG.name]
    key_name = "ukp"
    root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    }
    user_data = <<EOF
         #!/bin/bash
         sudo yum update -y
         sudo yum install -y docker
         sudo sed -i -e 's/#Port 22/Port 42/g' /etc/ssh/sshd_config
         sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
         sudo systemctl restart sshd
         sudo mkdir ~/site-content
         sudo systemctl start docker
         sudo systemctl enable docker
         sudo echo "Hello, BT EE and Plusnet" > ~/site-content/hello.html
         sudo docker run --name test-nginx-bt -p 80:80 --restart always -d -v ~/site-content:/usr/share/nginx/html nginx
         sudo docker run -d --name=test-bt-netdata \
                -p 9095:9095 \
                -v netdataconfig:/etc/netdata \
                -v netdatalib:/var/lib/netdata \
                -v netdatacache:/var/cache/netdata \
                -v /etc/passwd:/host/etc/passwd:ro \
                -v /etc/group:/host/etc/group:ro \
                -v /proc:/host/proc:ro \
                -v /sys:/host/sys:ro \
                -v /etc/os-release:/host/etc/os-release:ro \
                --restart always \
                --cap-add SYS_PTRACE \
                --security-opt apparmor=unconfined \
                netdata/netdata
         --//
	EOF
    tags = {
        Name = "Plusnet_Envionment"
        Environment = "Test"
    }
}