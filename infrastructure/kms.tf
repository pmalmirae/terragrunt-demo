/******************************
# KMS Key for encrypting data in transit and at rest
******************************/

# Creates/manages KMS CMK
resource "aws_kms_key" "data_key" {
  description              = "Terragrunt Demo Data Encryption Key"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"
  enable_key_rotation      = true
  policy                   = data.aws_iam_policy_document.ssm_key.json
  deletion_window_in_days  = 10
}

# Add an alias to the key
resource "aws_kms_alias" "data_key_alias" {
  name          = "alias/data-key"
  target_key_id = aws_kms_key.data_key.key_id
}

# An IAM Policy for the key enabling root user to manage the key and enabling CloudWatch logging
data "aws_iam_policy_document" "ssm_key" {
    statement {
        sid       = "Enable all permissions for root user"
        effect    = "Allow"
        actions   = ["kms:*"]
        resources = ["*"]

        principals {
            type        = "AWS"
            identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
        }
    }

    statement {
        sid         = "Enable CloudWatch Permissions on all log groups in region"
        effect      = "Allow"

        principals {
            type        = "Service"
            identifiers = ["logs.${var.aws_region}.amazonaws.com"]
        }

        actions = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
        ]
        
        resources = ["*"]

        condition {
            test        = "ArnLike"
            variable    = "kms:EncryptionContext:aws:logs:arn"
            values       = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:*"]
        }
    }
}
