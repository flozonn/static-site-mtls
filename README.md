# TERRAFORM MODULE aws_static_site_mtls 

# Examples:

## Deploy a static website in 3 A-Z:
```Terraform
module "site" {
  source                     = "git@gitlab.app.flozonn.com:arc/poc/aws_static_site_mtls.git?ref=v1.0.25"
  vpc_id                     = "vpc-010bb1f72aaaa8bbb"
  vpc_public_subnets         = ["subnet-0256e0e800295b3f7", "subnet-04dc53eab8ee0fca9", "subnet-064d65425179c6b24"]
  s3_vpc_endpoint_id         = "vpce-0b0cd1c2dce3f3657"
  alb_name                   = "s3-asyncapi"
  domain                     = "bus-events.arc.poc.flozonn.co"
  hosted_zone                = "arc.poc.flozonn.co"
  html_file_path             = "./index.html"
  trust_store_bucket_name    = "certs"
  trust_store_bucket_pem_key = "chain2.pem"
  env_name                   = "dev"
  squad_owner                = "archi"
}
```
## Schema 
![archi](./domotix-private_website.jpg)
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_lb.internal_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.https_forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.s3_vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.s3_vpce_attachment_subnet1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.s3_vpce_attachment_subnet2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_trust_store.flozonn_pki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_trust_store) | resource |
| [aws_route53_record.a_subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.a_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.index_html](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_network_interface.eni0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.eni1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_vpc_endpoint.s3_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The ALB name | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name of the static site, must refer to a route53 hosted zone | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | dev preprod prod | `string` | n/a | yes |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | The route53 hosted zone name | `string` | n/a | yes |
| <a name="input_html_file_path"></a> [html\_file\_path](#input\_html\_file\_path) | The local file path of the site's content to be published | `string` | n/a | yes |
| <a name="input_s3_vpc_endpoint_id"></a> [s3\_vpc\_endpoint\_id](#input\_s3\_vpc\_endpoint\_id) | The S3 vpc endpoint ID in the VPC | `string` | n/a | yes |
| <a name="input_squad_owner"></a> [squad\_owner](#input\_squad\_owner) | the squad this module is deployed for | `string` | n/a | yes |
| <a name="input_trust_store_bucket_name"></a> [trust\_store\_bucket\_name](#input\_trust\_store\_bucket\_name) | The bucket name containing the trusted certificate chain | `string` | n/a | yes |
| <a name="input_trust_store_bucket_pem_key"></a> [trust\_store\_bucket\_pem\_key](#input\_trust\_store\_bucket\_pem\_key) | The object key containing the trusted certificate | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id the ALB will be created in | `string` | n/a | yes |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | The list of public subnet ids containing the ALB | `list(string)` | n/a | yes |

## Outputs

No outputs.
