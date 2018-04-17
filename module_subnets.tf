module "subnets" {
  source = "github.com/sebolabs/subnets-tf"

  project     = "${var.project}"
  environment = "${var.environment}"
  component   = "${var.component}"
  name        = "${var.name}"

  vpc_id                  = "${var.vpc_id}"
  availability_zones      = ["${data.aws_availability_zones.available.names}"]
  cidrs                   = ["${var.subnets_cidrs}"]
  map_public_ip_on_launch = false
  route_tables            = ["${var.subnets_private_route_tables}"]

  default_tags = "${var.default_tags}"
}
