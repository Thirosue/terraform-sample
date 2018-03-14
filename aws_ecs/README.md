# ECS provisioning

Teraformを用いる

## access_key / secret_key

terraform.tfvarsに記載

```
$ cat terraform.tfvars
access_key="[アクセスキー記載]"
secret_key="[シークレットキーを記載]"
aws_id="[AWS IDを記載]"
```

## plan

```
terraform plan -var "aws_key_pair=[AWS EC2 Key Pair]"
```

## apply

```
terraform apply -var "aws_key_pair=[AWS EC2 Key Pair]"
```

## show

```
terraform show
```

## destory :boom:

```
terraform destroy -var "aws_key_pair=[AWS EC2 Key Pair]"
```
