terraform {
  backend "s3" {
    bucket       = "varun-terraform-state-900053548419"
    key          = "aws-kubernetes-devsecops-platform/dev/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
