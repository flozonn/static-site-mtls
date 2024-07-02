resource "aws_lb" "internal_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets = var.vpc_public_subnets

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.alb_name}-sg" 
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_lb_target_group" "s3_vpce" {
  name        = "s3-internal-website-vpce"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

data "aws_vpc_endpoint" "s3_endpoint" {
  id = var.s3_vpc_endpoint_id
}

data "aws_network_interface" "eni0" {
  id = tolist(data.aws_vpc_endpoint.s3_endpoint.network_interface_ids)[0]
}
data "aws_network_interface" "eni1" {
  id = tolist(data.aws_vpc_endpoint.s3_endpoint.network_interface_ids)[1]
}

resource "aws_lb_target_group_attachment" "s3_vpce_attachment_subnet1" {
  target_group_arn = aws_lb_target_group.s3_vpce.arn
  target_id        = data.aws_network_interface.eni0.private_ips[0]
  port             = 443
}

resource "aws_lb_target_group_attachment" "s3_vpce_attachment_subnet2" {
  target_group_arn = aws_lb_target_group.s3_vpce.arn
  target_id        = data.aws_network_interface.eni1.private_ips[0]
  port             = 443
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-0-2015-04"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.s3_vpce.arn
  }
  mutual_authentication {
    mode            = "verify"
    trust_store_arn = aws_lb_trust_store.flozonn_pki.arn
  }
}

// MTLS ALB config
resource "aws_lb_trust_store" "flozonn_pki" {
  name = "s3siteTS"

  ca_certificates_bundle_s3_bucket = var.trust_store_bucket_name
  ca_certificates_bundle_s3_key    = var.trust_store_bucket_pem_key
}