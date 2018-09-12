#!/bin/bash

PUPPETSERVER_HOSTNAME="${PUPPETSERVER_HOSTNAME:-puppet}"
if [ ! -d "/etc/puppetlabs/puppetdb/ssl" ]; then
  # Generate or import the certificates to be used
  if [ -n "$USE_PUPPET_CERTS" ]; then
    # Check for certs being in /etc/puppetlabs/puppet/ssl
    if [ ! -d "/etc/puppetlabs/puppet/ssl" ]; then
      echo "Unable to find /etc/puppetlabs/puppet/ssl when importing certs"
      echo 1
    fi

    mkdir -p /etc/puppetlabs/puppetdb/ssl
    cp /etc/puppetlabs/puppet/ssl/certs/ca.pem /etc/puppetlabs/puppetdb/ssl/ca.pem
    cp /etc/puppetlabs/puppet/ssl/private_keys/$HOSTNAME.pem /etc/puppetlabs/puppetdb/ssl/private.pem
    cp /etc/puppetlabs/puppet/ssl/ca/signed/$HOSTNAME.pem /etc/puppetlabs/puppetdb/ssl/public.pem
  else
    # Generate a new set of certs for this host
    while ! nc -z "$PUPPETSERVER_HOSTNAME" 8140; do
      sleep 1
    done
    set -e
    /opt/puppetlabs/bin/puppet config set certname "$HOSTNAME"
    /opt/puppetlabs/bin/puppet config set server "$PUPPETSERVER_HOSTNAME"
    /opt/puppetlabs/bin/puppet agent --verbose --onetime --no-daemonize --waitforcert 120
    /opt/puppetlabs/server/bin/puppetdb ssl-setup -f
  fi
fi

exec /opt/puppetlabs/server/bin/puppetdb "$@"
