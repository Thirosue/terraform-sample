# Fargate provisioning

Teraformを用いる

## access_key / secret_key

terraform.tfvarsに記載

```
$ cat terraform.tfvars
access_key="[アクセスキー記載]"
secret_key="[シークレットキーを記載]"
```

## plan

```
terraform plan
```

use vars

```
terraform plan -var 'aws_id=[AWS Account Id]'
```

## apply

```
terraform apply
```

use vars

```
terraform apply -var 'aws_id=[AWS Account Id]'
```

## show

```
terraform show
```

## destory :boom:

```
terraform destory
```

use vars

```
terraform destroy -var 'aws_id=[AWS Account Id]'
```
