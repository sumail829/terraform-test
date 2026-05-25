variable "CLOUDFLARE_API_TOKEN" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "db_password" {
  sensitive = true
}