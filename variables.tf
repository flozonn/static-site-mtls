variable "vpc_id" {
  type        = string
  description = "The VPC id the ALB will be created in"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "The list of public subnet ids containing the ALB"
}

variable "s3_vpc_endpoint_id" {
  type        = string
  description = "The S3 vpc endpoint ID in the VPC"
}

variable "alb_name" {
  type        = string
  description = "The ALB name"
}

variable "domain" {
  type        = string
  description = "The domain name of the static site, must refer to a route53 hosted zone"
}
variable "hosted_zone" {
  type        = string
  description = "The route53 hosted zone name"
}
variable "trust_store_bucket_name" {
  type        = string
  description = "The bucket name containing the trusted certificate chain"
}
variable "trust_store_bucket_pem_key" {
  type        = string
  description = "The object key containing the trusted certificate"
}
