#
## LOCALS
locals {
    required_tags = {
        project     = var.project_name
        environment = var.environment
  }
  tags = merge(var.resource_tags, local.required_tags)

}
data "aws_caller_identity" "current" {}

## main data bucket
resource "aws_s3_bucket" "main_s3_bucket" {
  bucket = var.s3_main_bucket_name
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
  tags = local.tags
}

resource "aws_s3_bucket_policy" "main_s3_bucket_policy" {
  bucket = aws_s3_bucket.test_example.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3-secure-access-policy"
    Statement = [{
      Sid = "S3-secure-access-policy-use-tls"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "s3:*"
      Resource = "${aws_s3_bucket.main_s3_bucket.arn}/*"
      Condition = {
        Bool = {
          "aws:SecureTransport" = true
        }
      }
    }
    # ,{
    #   Sid = "S3-secure-access-policy-use-tls-from-batch"
    #   Effect = "Allow"
    #   Principal = {
    #     AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/igf_pipeline-_batch_exec_role"
    #   }
    #   Action   = "s3:GetObject"
    #   Resource = "${aws_s3_bucket.main_s3_bucket.arn}/*"
    #   Condition = {
    #     Bool = {
    #       "aws:SecureTransport" = true
    #     }
    #   }
    # }
    ]
  })
}

## acl
resource "aws_s3_bucket_acl" "main_s3_bucket" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.main_s3_bucket_acl_ownership]
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_ownership_controls" "main_s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

## versioning
resource "aws_s3_bucket_versioning" "main_s3_bucket_versioning" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

## lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "main_s3_bucket" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  rule {
    id      = "lifecycle-rule1"
    expiration {
      days = var.s3_main_bucket_expiration_days
    }
    noncurrent_version_expiration {
      noncurrent_days = 10
    }
    abort_incomplete_multipart_upload {
        days_after_initiation = 5
    }
    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

## log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.s3_logging_bucket_name

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_acl_ownership]

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_acl_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log_example" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id      = "lifecycle-runs"

    filter {
        prefix = "logs/"
      }
    expiration {
      days = 90
    }

    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_logging" "main_s3_bucket" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

## static resource bucket
resource "aws_s3_bucket" "static_resource_s3_bucket" {
  bucket = var.s3_static_resource_bucket_name
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
  tags = local.tags
}

resource "aws_s3_bucket_policy" "static_resource_s3_bucket_policy" {
  bucket = aws_s3_bucket.static_resource_s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "S3-secure-access-policy"
    Statement = [{
      Sid = "S3-secure-access-policy-use-tls"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "s3:*"
      Resource = "${aws_s3_bucket.main_s3_bucket.arn}/*"
      Condition = {
        Bool = {
          "aws:SecureTransport" = true
        }
      }
     }#,{
    #   Sid = "S3-secure-access-policy-use-tls-from-batch"
    #   Effect = "Allow"
    #   Principal = {
    #     AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/igf_pipeline-_batch_exec_role"
    #   }
    #   Action   = "s3:GetObject"
    #   Resource = "${aws_s3_bucket.main_s3_bucket.arn}/*"
    #   Condition = {
    #     Bool = {
    #       "aws:SecureTransport" = true
    #     }
    #   }
    # }
    ]
  })
}

## acl
resource "aws_s3_bucket_acl" "static_resource_s3_bucket" {
  bucket = aws_s3_bucket.static_resource_s3_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.static_resource_s3_bucket_acl_ownership]
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_ownership_controls" "static_resource_s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_resource_s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

## lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "static_resource_s3_bucket" {
  bucket = aws_s3_bucket.static_resource_s3_bucket.id

  rule {
    id      = "lifecycle-rule1"
    expiration {
      days = 120
    }
    abort_incomplete_multipart_upload {
        days_after_initiation = 5
    }
    status = "Enabled"
  }
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "static_resource_s3_bucket_ia" {
  bucket = aws_s3_bucket.static_resource_s3_bucket.id
  name   = "EntireBucket"
  tiering {
    access_tier = "STANDARD_IA"
    days        = 30
  }
}