resource "aws_iam_role" "instance_iam_role" {

  name = "${var.prefix}_instance_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# IAM kms secretsmanager policy

resource "aws_iam_role_policy" "kms_sm_access_policy" {
  name = "${var.prefix}_kms_sm_access_policy"
  role = "${aws_iam_role.instance_iam_role.name}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "${var.secretsmanger_key_arn}"
    },
    {
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "${var.kms_key_arn}"
    }
  ]
}
EOF
}
