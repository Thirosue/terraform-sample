## Require
+ VIP
+ ssh_key
+ security group for dmz
+ securety group for internal
+ IAM(ecsInstanceRole,ecsServiceRole)
+ AccessKey/SecretKey(secret.tfvars)

## plan
```
terraform plan -var-file=../secret.tfvars \
 -var 'ssh_key_name=hirosue' \
 -var 'instance_type=t2.medium' \
 -var 'security_groups_internal=sg-41ecc325' \
 -var 'security_groups_dmz=sg-41ecc325' \
 -var 'hhvm_vip=internal-hhvm-892282372.ap-northeast-1.elb.amazonaws.com'
```

## apply
```
terraform apply -var-file=../secret.tfvars \
 -var 'ssh_key_name=hirosue' \
 -var 'instance_type=t2.medium' \
 -var 'security_groups_internal=sg-41ecc325' \
 -var 'security_groups_dmz=sg-41ecc325' \
 -var 'hhvm_vip=internal-hhvm-892282372.ap-northeast-1.elb.amazonaws.com'
```

## destroy

+ play
```
terraform plan -destroy -out=./terraform.tfstate -var-file=../secret.tfvars \
 -var 'ssh_key_name=hirosue' \
 -var 'instance_type=t2.medium' \
 -var 'security_groups_internal=sg-41ecc325' \
 -var 'security_groups_dmz=sg-41ecc325' \
 -var 'hhvm_vip=internal-hhvm-892282372.ap-northeast-1.elb.amazonaws.com'
```

+ do
```
terraform apply ./terraform.tfstate
```
