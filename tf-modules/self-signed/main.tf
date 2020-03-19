
// Create the root Certificate Authority key and cert
resource "tls_private_key" "this_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "local_file" "this_key" {
  filename = "${var.directory}/${var.prefix}.key"
  sensitive_content  = tls_private_key.this_key.private_key_pem
  file_permission = "0600"
}

resource "tls_self_signed_cert" "this_cert" {
  is_ca_certificate = true
  key_algorithm     = var.algorithm
  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
  private_key_pem = tls_private_key.this_key.private_key_pem
  subject {
    organization        = var.subject.O
    organizational_unit = var.subject.OU
    common_name         = var.subject.CN
  }
  dns_names = var.dns_names
  validity_period_hours = var.valid_days * 24
}

resource "local_file" "this_cert" {
  filename = "${var.directory}/${var.prefix}.pem"
  content  = tls_self_signed_cert.this_cert.cert_pem
  file_permission = "0644"
}