output "ec2_iam_role_arn" {
  value = "${aws_iam_role.instance_iam_role.arn}"
}