//
// Uncomment to manage state with Terraform Cloud
//

// terraform {
//    backend "remote" {
//        hostname = "app.terraform.io"
//        organization = ""
//
//        workspaces {
//            name = ""
//        }
//    }
// }

//
// Uncomment to manage state with AWS S3
//

// terraform {
//        backend "s3" {
//        bucket = ""
//        key    = ""
//        region = "us-west-1"
//    }
// }

// Sifchain terraform module
module sifchain {
    source                  = "github.com/sifchain/sifchain-deploy-public/terraform/providers/aws"
    region                  = "us-west-2"
    cluster_name            = "sifchain-aws-{{.cluster}}"
    tags = {
        Terraform           = true
        Project             = "sifchain"
    }
}
