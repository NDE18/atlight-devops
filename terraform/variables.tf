variable "cluster_name" {
  default = "atlight-eks"
  type    = string
}

variable "cluster_version" {
  default = "1.27"
  type    = string
}

variable "region" {
  default = "us-east-2"
  type    = string
}