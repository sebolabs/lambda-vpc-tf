resource "aws_lambda_function" "main" {
  function_name = "${format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    var.component,
    var.name
  )}"

  description = "${upper(var.name)} lambda function"

  s3_bucket = "${var.s3_bucket}"
  s3_key    = "${var.s3_key}"

  runtime     = "${var.runtime}"
  handler     = "${var.handler}"
  memory_size = "${var.memory_size}"
  timeout     = "${var.timeout}"
  publish     = "${var.publish}"

  role = "${aws_iam_role.main.arn}"

  vpc_config {
    subnet_ids = [
      "${module.subnets.subnet_ids}",
    ]

    security_group_ids = [
      "${aws_security_group.main.id}",
      "${var.additional_security_groups}",
    ]
  }

  environment {
    variables = "${var.env_variables}"
  }

  tags = "${merge(
    var.default_tags,
    local.tags,
    map(
      "Name", format(
        "%s-%s-%s-%s",
        var.project,
        var.environment,
        var.component,
        var.name
      )
    )
  )}"
}
