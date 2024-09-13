# Provider for AWS
#provider "aws" {
 # region = "us-east-1"  # Choose the region you prefer
#}

# Create S3 bucket for storing Terraform state
#resource "aws_s3_bucket" "terraform_state" {
 # bucket = "your-unique-terraform-state-bucket"  # Change this to a unique bucket name

  # Enable versioning for state tracking (recommended)
  #versioning {
   # enabled = true
  #}

  # Optional: Add server-side encryption for security

  #tags = {
   # Name        = "Terraform State Bucket"
    #Environment = "Dev"
  #}
#}

# Create IAM Policy to allow access to S3 bucket
#resource "aws_iam_policy" "terraform_state_access_policy" {
 # name        = "TerraformStateAccessPolicy"
  #description = "IAM policy to allow access to S3 bucket for Terraform state management"

  #policy = jsonencode({
   # Version = "2012-10-17",
    #Statement = [
     # {
      #  Effect = "Allow",
       # Action = [
        #  "s3:ListBucket",
         # "s3:GetObject",
          #"s3:PutObject",
          #"s3:DeleteObject"
        #],
        #Resource = [
         # "arn:aws:s3:::${aws_s3_bucket.terraform_state.bucket}",
          #"arn:aws:s3:::${aws_s3_bucket.terraform_state.bucket}/*"
        #]
      #}
    #]
  #})
#}

# Attach the IAM policy to a user or role (replace with your IAM user or role)
#resource "aws_iam_role_policy_attachment" "attach_policy" {
 # role       = "YourTerraformRole"  # Replace with your IAM Role
  #policy_arn = aws_iam_policy.terraform_state_access_policy.arn
#}

# Backend configuration to use the S3 bucket
#terraform {
 # backend "s3" {
  #  bucket         = aws_s3_bucket.terraform_state.bucket  # Reference to the S3 bucket
   # key            = "terraform.tfstate"                   # File to store the state
    #region         = "us-east-1"                           # Region where your bucket is created
    #encrypt        = true                                  # Enable encryption for the state file
  #}
#}

#provider "aws" {
 # region = "us-east-1"
#}

#resource "aws_s3_bucket" "example" {
 # bucket = "terraform-state-bucket"
#}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}
