terraform {
  backend "s3" {
    bucket = "ec2toecsmigration-tfstate"
    key    = "ec2-ecs-migration/terraform.tfstate"
    region = "eu-west-2"
  }
}