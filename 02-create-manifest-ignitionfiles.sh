#!/bin/bash

echo "Crear manifiestos y cambiar configuracion"
openshift-install create manifests

echo "Borrar archivos innecesarios"
rm -f openshift/99_openshift-cluster-api_master-machines-*.yaml openshift/99_openshift-cluster-api_worker-machineset-*.yaml

echo "Cambiar configuracion para schedule en masters"
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' manifests/cluster-scheduler-02-config.yml
cat manifests/cluster-scheduler-02-config.yml

echo "Crear archivos de inicializacion y configuracion"
openshift-install create ignition-configs

echo "Obtener el infraId"
jq -r .infraID metadata.json > infraId.txt

echo "Crear append-bootstrap para intermediario"
cat <<EOF > append-bootstrap.ign
{
  "ignition": {
    "config": {
      "append": [
        {
          "source": "http://150.238.44.132:8080/ignition/bootstrap.ign",
          "verification": {}
        }
      ]
    },
    "timeouts": {},
    "version": "2.2.0"
  },
  "networkd": {},
  "passwd": {},
  "storage": {},
  "systemd": {}
}
EOF

echo "Crear archivos base64"
for i in append-bootstrap bootstrap master worker; do base64 -w0 < $i.ign > $i.64; done

echo "Mover archivos a directorio de HTTP server"
rm -f /var/www/html/ignition/*
cp *.ign /var/www/html/ignition
chmod -R 777 /var/www/html/ignition/*
