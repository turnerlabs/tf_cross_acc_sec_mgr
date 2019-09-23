output "kms_key_arn" {
  value = "${aws_kms_key.kms_key.arn}"
}

output "secretsmanger_key_arn" {
  value = "${aws_secretsmanager_secret.secretmanager_secret.arn}"
}
