data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "app" {
  count = length(var.private_subnet_cidrs)

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private[count.index].id

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  user_data                   = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y python3 amazon-ssm-agent

              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent

              mkdir -p /opt/app

              cat <<'APP' > /opt/app/app.py
              from http.server import BaseHTTPRequestHandler, HTTPServer

              class Handler(BaseHTTPRequestHandler):
                  def do_GET(self):
                      if self.path == "/health":
                          self.send_response(200)
                          self.send_header("Content-Type", "text/plain")
                          self.end_headers()
                          self.wfile.write(b"healthy")
                      else:
                          self.send_response(200)
                          self.send_header("Content-Type", "text/plain")
                          self.end_headers()
                          self.wfile.write(b"AWS Kubernetes DevSecOps Platform")

              server = HTTPServer(("0.0.0.0", 8080), Handler)
              server.serve_forever()
              APP

              nohup python3 /opt/app/app.py > /var/log/app.log 2>&1 &
              EOF

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-${count.index + 1}"
    Tier = "private"
  })
}
