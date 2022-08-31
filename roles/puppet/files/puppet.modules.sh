#!/bin/bash
# EPEL repo
puppet module install puppet-epel
# UMD4 repo
puppet module install cnafsd-umd4
# NTP service
puppet module install puppetlabs-ntp
# fetch-crl and all CA certificates
puppet module install puppet-fetchcrl
# voms
puppet module install lcgdm-voms
# bdii
puppet module install cnafsd-bdii
# storm services and utils
puppet module install cnafsd-storm
# lcmaps module (only for test purpose)
puppet module install cnafsd-lcmaps