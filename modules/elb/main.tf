resource "aws_elb" "elb" {
  name               = "${env}-${app_name}-elb"
  availability_zones = "${az_list}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${ssl_cert_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 60

  tags {
    Name = "{env}-${app_name}-elb"
  }
}

resource "aws_elb_attachment" "elb_attachment" {
  elb      = "${aws_elb.elb.id}"
  instance = "${instance_id}"
}
