variable "nomad_provider" {
  type = object({
    address   = string
    secret_id = string
    ca_pem    = string
  })
  sensitive   = true
  description = "Nomad provider configuration"
}

variable "unifi_provider" {
  type = object({
    api_url = string
    api_key = string
  })
  sensitive   = true
  description = "UniFi provider configuration"
}

variable "nomad_job_vars" {
  description = "Variables for Nomad job templates"
  type        = object({
    domain     = string
    macs      = map(string)
  })
}
