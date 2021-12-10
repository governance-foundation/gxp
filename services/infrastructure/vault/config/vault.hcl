//ui enabled
ui = "true"

//debug enabled
log_level = "Debug"

//advertise this api address
api_addr = "http://vault:8200"

//advertise this cluster address
cluster_addr = "http://vault:8201"

//need this for windows
disable_mlock = true

//use storage that will be replicated
storage "raft" {
  path    = "/vault/file"
  node_id = "node1"
}

//run ui
listener "tcp" {
  address = "[::]:8200"
  tls_disable = "true"
}

//spit out metrics
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}

// user remote server to auto-unseal
// seal "transit" {
//   address = "https://rosterboss.localhost"
//   token  = "YG3baNxkUWURY6coVRbjqrs8BQWWBdGV"
//   disable_renewal = "false"

//   // Key configuration
//   key_name = "rosterboss"
//   mount_path = "transit/"
//   namespace = "ns1/"

//   // TLS Configuration
//   // tls_ca_cert        = "/etc/vault/ca_cert.pem"
//   // tls_client_cert    = "/etc/vault/client_cert.pem"
//   // tls_client_key     = "/etc/vault/ca_cert.pem"
//   // tls_server_name    = "vault"
//   tls_skip_verify    = "true"
// }

