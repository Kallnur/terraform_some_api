variable "tags" {
  description = "Tags to apply to Resources"
  default = {
    Owner   = "Kalnur"
  }
}

variable "name" {
  description = "Name to use for Resources"
  default     = "APIGateway-some-api"
}
