variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "profile" {
  description = "Profile from credentials"
  default     = "default"
}

variable "tag_application" {
    description = "This designates the application running"
}

variable "tag_contact_email" {
    description = "This should be the email of the individual that owns the resource"
}

variable "tag_customer" {
    description = "This designates the client or customer of the application, generally for the cost reporting and analysis"
}

variable "tag_team" {
    description = "Technical team that owns and or supports the resource"
}

variable "tag_environment" {
    description = "Should be dev, qa, uat or prod"
}

variable "prefix" {
  description = "Name to prefix all resource names with"
}

variable "account_b_role_name" {
  description = "Role Name"  
}