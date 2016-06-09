# terraform aws(ec2) provisioning sample

## required terraform
[Terraform](https://www.terraform.io/ "Terraform")

## setting
```sh
$ touch secret.tfvars
$ cat secret.tfvars
access_key="[write AWS accessKey]"
secret_key="[write AWS secretKey]"
```

## provision

+ plan
```sh
terraform plan -var-file=secret.tfvars
```

+  apply (do provisioning)
```sh
terraform apply -var-file=secret.tfvars
```

## destory (delete ec2)

+ plan
```sh
terraform plan -destroy -out=./terraform.tfstate -var-file=secret.tfvars
```

+ apply (do delete)
```sh
terraform apply ./terraform.tfstate
```
