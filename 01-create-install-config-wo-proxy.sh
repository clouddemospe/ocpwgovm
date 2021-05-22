#!/bin/bash

export DOMAIN=clouddemos.pe
export CLUSTERID=ocp4
export VCENTER_SERVER=150.238.44.130
export VCENTER_USER="administrator@clouddemos.pe"
export VCENTER_PASS='db2admin#ICP'
export VCENTER_DC=dc01
export VCENTER_DS=datastore1
export PULL_SECRET=$(< ~/.openshift/pull-secret-new.json)
export OCP_SSH_KEY=$(< ~/.ssh/id_rsa.pub)

cat <<EOF > install-config.yaml
apiVersion: v1
baseDomain: ${DOMAIN}
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ${CLUSTERID}
platform:
  vsphere:
    vcenter: ${VCENTER_SERVER}
    username: ${VCENTER_USER}
    password: ${VCENTER_PASS}
    datacenter: ${VCENTER_DC}
    defaultDatastore: ${VCENTER_DS}
    folder:
fips: false
pullSecret: '${PULL_SECRET}'
sshKey: '${OCP_SSH_KEY}'
EOF
