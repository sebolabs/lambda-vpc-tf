resource "aws_security_group" "main" {
  name = "${format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    var.component,
    var.name
  )}"

  description = "Main SG for ${upper(var.name)} Lambda function"

  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    var.default_tags,
    local.tags,
    map(
      "Name", format(
        "%s-%s-%s/%s",
        var.project,
        var.environment,
        var.component,
        var.name
      ),
    )
  )}"
}
