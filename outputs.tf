output "arn" {
  description = "Arn of generated certificate to be used on Cloudfronts,ALBs,etc..."
  value = aws_acm_certificate_validation.default.certificate_arn
}

# output "records" {
#   # value = cloudflare_record.validation.*.hostname
#   value = [for x in cloudflare_record.validation: x.hostname]
# }
