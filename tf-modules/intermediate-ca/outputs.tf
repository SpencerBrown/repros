output "cert" {
  value = tls_locally_signed_cert.this_cert.cert_pem
}

output "key" {
  value = tls_private_key.this_key.private_key_pem
}