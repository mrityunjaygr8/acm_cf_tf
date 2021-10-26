terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.3.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}
locals {
  zone_id = lookup(data.cloudflare_zones.selected_zone.zones[0], "id")
  subject_alternative_names = ["*.${var.domain_name}"]
}

data "cloudflare_zones" "selected_zone" {
  filter {
   name   = var.zone_name
  }
}

provider "aws" {
  profile = var.aws_profile
  region = var.region
}

provider "cloudflare" {
  # api_key = var.cf_api_key
}

resource "aws_acm_certificate" "default" {
  domain_name               = var.domain_name
  subject_alternative_names = local.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
  {
    Name = var.domain_name
  },
  var.tags,
  )
}

resource "cloudflare_record" "validation" {
  # todo support to alternates domains names
  # count    = length(local.subject_alternative_names)

  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      value = trimsuffix(dvo.resource_record_value, ".")
      type = dvo.resource_record_type
    }
  }

  zone_id = local.zone_id
  name = each.value.name
  type = each.value.type
  value = each.value.value
}

 resource "aws_acm_certificate_validation" "default" {
   certificate_arn = aws_acm_certificate.default.arn
   validation_record_fqdns = [for x in cloudflare_record.validation: x.hostname]
 }
