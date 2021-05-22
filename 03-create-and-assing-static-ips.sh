#!/bin/bash
export GOVC_USERNAME="administrator@vsphere.local"
export GOVC_PASSWORD="L1c@nTr0p4s"
export GOVC_URL=150.238.44.131

#BOOTSTRAP_MAC='00:50:56:8f:2b:1a'

IPCFG1="ip=150.238.44.132::150.238.44.129:255.255.255.240:bootstrap.ocp4.clouddemos.pe:ens192:none nameserver=150.238.44.130"
IPCFG2="ip=150.238.44.137::150.238.44.129:255.255.255.240:worker1.ocp4.clouddemos.pe:ens192:none nameserver=150.238.44.130"
IPCFG3="ip=150.238.44.138::150.238.44.129:255.255.255.240:worker2.ocp4.clouddemos.pe:ens192:none nameserver=150.238.44.130"
IPCFG4="ip=150.238.44.139::150.238.44.129:255.255.255.240:worker3.ocp4.clouddemos.pe:ens192:none nameserver=150.238.44.130"
IPCFG5="ip=169.60.44.68::169.60.44.67:255.255.255.192:master1.ocp4.clouddemos.pe:ens192:none nameserver=169.60.44.67 nameserver=150.238.44.130"
IPCFG6="ip=169.60.44.69::169.60.44.67:255.255.255.192:master2.ocp4.clouddemos.pe:ens192:none nameserver=169.60.44.67 nameserver=150.238.44.130"
IPCFG7="ip=169.60.225.92::169.60.225.91:255.255.255.248:master3.ocp4.clouddemos.pe:ens192:none nameserver=169.60.225.91 nameserver=150.238.44.130"

# Clone VMs
#govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public -net.address $BOOTSTRAP_MAC -vm "rhcos" bootstrap
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public -vm "rhcos" bootstrap
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public -c 16 -m 65536 -vm "rhcos" worker1
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public -c 16 -m 65536 -vm "rhcos" worker2
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public -c 16 -m 65536 -vm "rhcos" worker3
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public1 -c 8 -m 32768 -vm "rhcos" master1
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public1 -c 8 -m 32768 -vm "rhcos" master2
govc vm.clone -on=false -folder ocp4-txscx -ds datastore1 -net Public2 -c 8 -m 32768 -vm "rhcos" master3

# Add IP Address
govc vm.change -vm "bootstrap" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG1"
govc vm.change -vm "worker1" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG2"
govc vm.change -vm "worker2" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG3"
govc vm.change -vm "worker3" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG4"
govc vm.change -vm "master1" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG5"
govc vm.change -vm "master2" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG6"
govc vm.change -vm "master3" -e "guestinfo.afterburn.initrd.network-kargs=$IPCFG7"

# Change configuration
govc vm.change -vm "bootstrap" -e "guestinfo.ignition.config.data=$(cat append-bootstrap.64)"
govc vm.change -vm "worker1" -e "guestinfo.ignition.config.data=$(cat worker.64)"
govc vm.change -vm "worker2" -e "guestinfo.ignition.config.data=$(cat worker.64)"
govc vm.change -vm "worker3" -e "guestinfo.ignition.config.data=$(cat worker.64)"
govc vm.change -vm "master1" -e "guestinfo.ignition.config.data=$(cat master.64)"
govc vm.change -vm "master2" -e "guestinfo.ignition.config.data=$(cat master.64)"
govc vm.change -vm "master3" -e "guestinfo.ignition.config.data=$(cat master.64)"


# Power on VMs
govc vm.power -on "bootstrap" "master1" "master2" "master3" "worker1" "worker2" "worker3"
