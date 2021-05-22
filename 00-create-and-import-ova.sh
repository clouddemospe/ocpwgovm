#!/bin/bash
export GOVC_USERNAME="administrator@clouddemos.pe"
export GOVC_PASSWORD="db2admin#ICP"
export GOVC_URL=150.238.44.130
versionx="4.3"

govc import.ova -k -ds datastore1 -name "rhcos-$versionx" ./rhcos-$versionx.*.ova

govc vm.change -k -vm "rhcos-$versionx" -e "guestinfo.ignition.config.data=base64"
govc vm.change -k -vm "rhcos-$versionx" -e "guestinfo.ignition.config.data.encoding=base64"
govc vm.change -k -vm "rhcos-$versionx" -e "disk.EnableUUID=TRUE"
