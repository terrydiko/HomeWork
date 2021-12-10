variable "instance_ami" {
    type = string
    default = "ami-0ed9277fb7eb570c9"
}
variable "instance_type" {
    type = string 
    default = "t2.micro"
}

variable "webkeypair" {
    type = string 
    default = "NVirginiaKeyPair"
}