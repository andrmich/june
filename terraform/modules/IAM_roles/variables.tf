variable "namespace" {
  type    = string
  default = "june"
}
variable "environment" {
  type    = string
  default = "test"
}
variable "name" {
  type    = string
  default = "deny_all"
}
variable "tags" {
  type    = map(string)
  default = {}
}