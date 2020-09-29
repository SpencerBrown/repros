// Create the key and cert for a server or client or an intermediate signing cert

resource "tls_private_key" "this_key" {
  algorithm = var.algorithm
  rsa_bits = var.rsa_bits
}

resource "tls_cert_request" "this_cr" {
  key_algorithm = var.algorithm
  private_key_pem = tls_private_key.this_key.private_key_pem
  subject {
    organization = var.subject.O
    organizational_unit = var.subject.OU
    common_name = var.subject.CN
  }
}

resource "tls_locally_signed_cert" "this_cert" {
  cert_request_pem = tls_cert_request.this_cr.cert_request_pem
  ca_key_algorithm = var.algorithm
  ca_private_key_pem = var.ca_key
  ca_cert_pem = var.ca_cert
  is_ca_certificate = false
  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_encipherment",
  ]
  validity_period_hours = var.valid_days * 24
}

resource "local_file" "this_key" {
  filename = "${var.directory}/${var.prefix}.key"
  sensitive_content = tls_private_key.this_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "this_cert" {
  filename = "${var.directory}/${var.prefix}.pem"
  content = tls_locally_signed_cert.this_cert.cert_pem
  file_permission = "0644"
}

resource "local_file" "this_key_cert" {
  filename = "${var.directory}/${var.prefix}-key-cert.pem"
  sensitive_content = "${tls_private_key.this_key.private_key_pem}${tls_locally_signed_cert.this_cert.cert_pem}"
  file_permission = "0600"
}
