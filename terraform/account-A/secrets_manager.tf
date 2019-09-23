
resource "aws_secretsmanager_secret" "secretmanager_secret" {
  name                    = "${var.prefix}_secretmanager_secret"
  recovery_window_in_days = 7
  kms_key_id              = "${aws_kms_key.kms_key.arn}"

  tags = {
    application     = "${var.tag_application}"
    contact-email   = "${var.tag_contact_email}"
    customer        = "${var.tag_customer}"
    team            = "${var.tag_team}"
    environment     = "${var.tag_environment}"
  }

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::${var.account_b_number}:role/${var.account_b_role_name}"},
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*",
      "Condition": {"ForAnyValue:StringEquals": {"secretsmanager:VersionStage": "AWSCURRENT"}}
    }
  ]
}
EOF  
}

resource "aws_secretsmanager_secret_version" "secretmanager_secret_version" {
  secret_id     = "${aws_secretsmanager_secret.secretmanager_secret.id}"
  secret_string = "${var.secret_to_store}"
}