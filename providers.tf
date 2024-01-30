provider "aws" {
  alias = "source"
  region = "us-west-1"
}

provider "aws" {
  alias  = "destination"
  region = "us-east-1"
}