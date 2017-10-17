#
# Variabled for the DEVELOPMENT environment. Tune according to your needs
#

variable "environment" {
  type = "string"
  default = "dev"
}
variable "caching_nodes_number" {
  type = "string"
  default = "1"
}
variable "db_nodes_number" {
  type = "string" 
  default = "2"
}
