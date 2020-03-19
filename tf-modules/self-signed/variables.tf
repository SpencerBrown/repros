variable "subject" {
  description = "Subject for self-signed rertificate"
  type        = map(string)
  default = {
    O  = "MongoDB"
    OU = "Example"
    CN = "Root CA"
  }
}

variable "algorithm" {
  description = "Crypto algorithm (only RSA supported right now)"
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
  description = "Prefix to assign to filenames, e.g. ca.pem, ca.key"
  default     = "root-ca"
}

variable "directory" {
  description = "Directory where files should be written"
  default     = "tls-certs"
}

// make certificate that can only sign other certificates
variable "ca_only" {
  type    = bool
  default = true
}

// Hosts for SAN list; default is no SAN list
variable "dns_names" {
  type    = list(string)
  default = []
}
