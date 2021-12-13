<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.20.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | terraform-aws-modules/dynamodb-table/aws | 1.1.0 |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.11.1 |
| <a name="module_state_bucket"></a> [state\_bucket](#module\_state\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.11.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.objects](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamodb_table_billing_mode"></a> [dynamodb\_table\_billing\_mode](#input\_dynamodb\_table\_billing\_mode) | n/a | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "Environment": "stage",<br>  "Owner": "Artem",<br>  "Terraform": true,<br>  "Type": ""<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfstate_bucket_name"></a> [tfstate\_bucket\_name](#output\_tfstate\_bucket\_name) | n/a |
| <a name="output_tfstate_dynamodb_lock"></a> [tfstate\_dynamodb\_lock](#output\_tfstate\_dynamodb\_lock) | n/a |
<!-- END_TF_DOCS -->