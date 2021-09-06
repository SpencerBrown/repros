// The private keys are stored UNENCRYPTED in the Terraform state file, so use this for testing only.

// Create the  "public" root Certificate Authority key and cert

module "public-root-ca" {
  source = "github.com/SpencerBrown/tlscerts/root-ca"
  prefix = "public-ca"
  subject = {
    O  = "MongoDB"
    OU = "Public"
    CN = "Root CA"
  }
}

// Create the public intermediate signing CA certificate

module "public-signing-ca" {
  source  = "github.com/SpencerBrown/tlscerts/intermediate-ca"
  prefix  = "public-signing-ca"
  ca_cert = module.public-root-ca.cert
  ca_key  = module.public-root-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Public"
    CN = "Signing CA"
  }
}

// Create the Server key and CA-signed cert
// in normal deployments, we would create one server cert per server, with its hostname specified

module "public-server-cert" {
  source  = "github.com/SpencerBrown/tlscerts/server"
  prefix  = "public-server"
  ca_cert = module.public-signing-ca.cert
  ca_key  = module.public-signing-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Public"
    CN = "Server"
  }
  dns_names = [
    "mongodb-local.computer",
    "repro"
  ]
}

// Create the Client key and CA-signed cert

module "client-cert" {
  source  = "github.com/SpencerBrown/tlscerts/client"
  prefix  = "client"
  ca_cert = module.public-signing-ca.cert
  ca_key  = module.public-signing-ca.key
  subject = {
    O  = "MongoDB"
    OU = "Public-Client"
    CN = "Client"
  }
}
