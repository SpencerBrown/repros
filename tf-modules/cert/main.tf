
// Create the key and cert for a server or client or an intermediate signing cert
resource "tls_private_key" "this_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "local_file" "this_key" {
  filename = "${var.directory}/${var.prefix}.key"
  content  = tls_private_key.this_key.private_key_pem
}

resource "tls_cert_request" "this_cr" {
  key_algorithm   = var.algorithm
  private_key_pem = tls_private_key.this_key.private_key_pem
  subject {
    organization        = var.subject.O
    organizational_unit = var.subject.OU
    common_name         = var.subject.CN
  }
  dns_names = var.dns_names
}

resource "tls_locally_signed_cert" "this_cert" {
  cert_request_pem      = tls_cert_request.this_cr.cert_request_pem
  ca_key_algorithm      = var.algorithm
  ca_private_key_pem    = var.ca_key
  ca_cert_pem           = var.ca_cert
  is_ca_certificate     = var.ca_only ? true : false
  allowed_uses          = var.ca_only ? ["cert_signing", "crl_signing", "digital_signature"] : (var.client_only ? ["client_auth"] : ["server_auth", "client_auth"])
  validity_period_hours = var.valid_days * 24
}

resource "local_file" "this_cert" {
  filename = "${var.directory}/${var.prefix}.pem"
  content  = tls_locally_signed_cert.this_cert.cert_pem
}

resource "local_file" "this_key_cert" {
  filename = "${var.directory}/${var.prefix}-key-cert.pem"
  content  = "${tls_private_key.this_key.private_key_pem}${tls_locally_signed_cert.this_cert.cert_pem}"
}

resource "local_file" "this_key_cert_ca" {
  filename = "${var.directory}/${var.prefix}-key-cert-ca.pem"
  content  = "${tls_private_key.this_key.private_key_pem}${tls_locally_signed_cert.this_cert.cert_pem}${var.ca_cert}"
}
