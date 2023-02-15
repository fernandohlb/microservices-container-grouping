provider "aws" {}

terraform {
	required_providers {
		aws = {
	    version = "~> 4.52.0"
		}
  }
}
