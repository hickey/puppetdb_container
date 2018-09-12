puppetdb_container
==================
This is a fork of the Puppetlabs PuppetDB container that supports external
collateral. 

Container Controls
------------------
The following environmental variables are recognized by the contianer:

PUPPETSERVER_HOSTNAME: FQDN of the Puppet master. If not specified, it
will default to 'puppet'.

HOSTNAME: Used to set the cert ID for the certificate.

USE_PUPPET_CERTS: If set to true, then certificates will be copied from
`/etc/puppetlabs/puppet/ssl`. HOSTNAME must be defined to be the FQDN of
the host to import the certificates for.  This will short-circuit the
normal startup that the container does and reach out to the Puppet master
to retreive the certificates.

PUPPETDB_PASSWORD

PUPPETDB_USER:

PUPPETDB_DATABASE_CONNECTION:


Other Notes
-----------

* When building the container, insure that the desired PuppetDB version
  is set in the Dockerfile.
