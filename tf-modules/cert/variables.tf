
variable "algorithm" {
  description = "Crypto algorithm (only RSA supported right now"
  default     = "RSA"
}

variable "rsa_bits" {
  description = "Length of RSA key"
  default     = 2048
}

variable "valid_days" {
  description = "Number of days before certificate expires"
  default     = 365
}

variable "prefix" {
  description = "Prefix to assign to filenames, e.g. server.pem, server.key, server-bundle.pem"
}

variable "directory" {
  description = "Directory where files should be written"
  default     = "tls-certs"
}

variable "ca_cert" {
  description = "CA certificate for signing"
}

variable "ca_key" {
  description = "CA private key for signing"
}

variable "subject" {
  description = "Subject for certificate"
  type        = map
  default = {
    O  = "MongoDB"
    OU = "Example"
    CN = "Server"
  }
}

variable "dns_names" {
  type    = list
  default = []
}

variable "client_only" {
  type    = bool
  default = false
}

variable "ca_only" {
  type    = bool
  default = false
}