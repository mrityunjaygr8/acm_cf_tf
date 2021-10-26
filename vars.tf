variable "domain_name" {
  type        = string
  description = "Primary certificate domain name"
}
variable "zone_name" {
  type        = string
  description = "Domain zone name"
}

variable "validation_record_ttl" {
  default     = 60
  type        = number
  description = "Cloudflare time-to-live for validation records"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the ACM certificate"
}

variable "region" {
  default = "us-east-1"
  description = "Aws region to  ACM certificate"
}

variable "aws_profile" {
  description = "The AWS profile to be used"
}

# Configure the Cloudflare Provider
/* variable "cf_email" {
  description = "The email associated with the account. This can also be specified with the CLOUDFLARE_EMAIL shell environment variable."
}
*/

/* variable "cf_api_key" {
  description = "The Cloudflare API key. This can also be specified with the CLOUDFLARE_API_KEY shell environment variable."
} */

