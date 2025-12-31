# apply .env file
source .env

# create terraform project
terraform init

# apply terraform changes
terraform plan
terraform apply

# after update
terraform apply

# destroy resource
terraform destroy

# validate terraform file
terraform validate
