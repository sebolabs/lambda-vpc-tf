# lambda-vpc-tf

**Info**
------
This Terraform module creates a Lambda function along with VPC subnets and a core security group as well as a minimum set of other resource required to cover basic Lambda functionalities.

**_Note:_** This module expects s3_key value to be provided in order to deploy code to the Lambda function.

**Usage**
------
```python
module "my-vpc-lambda" {
  source = "github.com/sebolabs/lambda-vpc-tf.git"

  project     = "lab"
  environment = "test"
  component   = "my-app"
  name        = "my-lambda"

  s3_bucket = "my-bucket"
  s3_key    = "packages/my-package.zip"

  runtime     = "nodejs6.10"
  handler     = "lambda.handler"
  memory_size = "128"
  timeout     = "5"
  publish     = false

  principal_service = "apigateway"

  invoker_source_arn = "${format(
    "%s:%s:%s:%s/%s",
    "arn:aws:execute-api",
    var.aws_region,
    data.aws_caller_identity.current.account_id,
    aws_api_gateway_rest_api.main.id,
    "*/*/*"
  )}"

  vpc_id                       = "${aws_vpc.lambda.id}"
  subnets_cidrs                = ["${var.lambda_subnet_cidrs}"]
  subnets_private_route_tables = ["${aws_route_table.private.*.id}"]
  additional_security_groups   = ["${aws_security_group.lambda.id}"]

  env_variables = "${merge(
    var.env_vars,
    map(
      "MY_ENV", "TEST"
    )
  )}"

  cwlg_retention_in_days = 3
}
```

**Terraform compatibility**
------
TF versions tested: 0.11.7

**Dependencies**
------
1. subnets-tf
