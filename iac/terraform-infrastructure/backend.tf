# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "s3-terraform-for-k8s-fibo"
    key            = "terraform-modules/fibonacci/terraform.tfstate"
    region         = "us-east-1"
    profile        = "devops"
    dynamodb_table = "terraform-state-lock"
  }
}