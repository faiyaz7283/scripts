#!/usr/bin/env bash
set -euo pipefail

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

master_host="${1:-192.168.1.175:6443}"
token="$(kubeadm token generate)"
ca_cert_hash="$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
		 openssl rsa -pubin -outform der 2>/dev/null | \
		 openssl dgst -sha256 -hex | sed 's/^.* //')"


echo $master_host
exit

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

set_token() {
  kubeadm token create $token 
}

del_token() {
  kubeadm token delete $token
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

# Set the token for use
set_token

# Join the cluster
kubeadm join $master_host --token $token --discovery-token-ca-cert-hash $ca_cert_hash

# Cleanup the token
del_token
