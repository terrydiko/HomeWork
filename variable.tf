variable "myVPCCidr" {
  type = string
  default = "10.1.0.0/16"
}
variable "myPriSubCidr" {
    type = string
    default = "10.1.1.0/24"
}
variable "myPubSubCidr" {
    type = string
    default = "10.1.2.0/24"
}
variable "myAZ" {
    type = string
    default = "us-east-1a"
  }
 variable "instance_type" {
    type = string
    default = "t2.micro"
  }
variable "key_name" {
    type = string
    default = "publickeypair"
  }
variable "ami" {
    type = string
    default = "ami-083654bd07b5da81d"
  }
  variable "image_id" {
      type = string
      default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"  
  }
  variable "bucket_name" {
    type = string
  }
  variable "role_name" {
    type = string
  }