// The private keys are stored UNENCRYPTED in the Terraform state file, so use this for testing only.

// Create the  "public" root Certificate Authority key and cert

module "public-root-ca" {
  source = "./tf-modules/self-signed"
  prefix = "public-ca"
  subject = {
    O  = "MongoDB"
    OU = "Public"
    CN = "Root CA"
  }
}

// Create the  "internal" root Certificate Authority key and cert

module "internal-root-ca" {
  source = "./tf-modules/self-signed"
  prefix = "internal-ca"
  subject = {
    O  = "MongoDB"
    OU = "Internal"
    CN = "Root CA"
  }
}

// Create the Internal Server key and CA-signed cert
// in normal deployments, we would create one server cert per server, with its hostname specified

module "internal-server-cert" {
  source  = "./tf-modules/cert"
  prefix  = "internal-server"
  ca_cert = module.internal-root-ca.cert
  ca_key  = module.internal-root-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Internal"
    CN = "Server"
  }
  dns_names = [
    "mongodb-local.computer",
    "repro",
  ]
}

// Create the Public Server key and CA-signed cert
// in normal deployments, we would create one server cert per server, with its hostname specified

module "public-server-cert" {
  source  = "./tf-modules/cert"
  prefix  = "public-server"
  ca_cert = module.public-root-ca.cert
  ca_key  = module.public-root-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Public"
    CN = "Server"
  }
  dns_names = [
    "mongodb-local.computer",
    "repro",
  ]
}

// Create the Client key and CA-signed cert

module "client-cert" {
  source  = "./tf-modules/cert"
  prefix  = "client"
  ca_cert = module.public-root-ca.cert
  ca_key  = module.public-root-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Public-Client"  // cannot be "Public" as that would match O/OU and be an internal user
    CN = "Client"
  }
  client_only = true
}

// Create a self-signed server cert for standalone testing

module "selfsigned-cert" {
  source  = "./tf-modules/self-signed"
  prefix  = "selfsigned"
  ca_only = false
  subject = {
    O  = ""
    OU = ""
    CN = "*.example.com"
  }
  dns_names = [
    "mongodb-local.computer",
    "repro",
  ]
}