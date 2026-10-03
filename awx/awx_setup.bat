#!/bin/bash

sudo apt update -y && sudo apt upgrade -y && sudo apt install git ansible curl wget python3-pip -y

curl -sfL https://get.k3s.io | sh -

sudo systemctl status k3s --no-pager
sudo kubectl get nodes

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

sed -i "s/127.0.0.1/$(hostname -I | awk '{print $1}')/g" ~/.kube/config

export KUBECONFIG=~/.kube/config

sudo kubectl create namespace awx

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

helm repo add awx-operator https://ansible-community.github.io/awx-operator-helm/
helm repo update

helm install awx-operator awx-operator/awx-operator -n awx

cat > awx-demo.yml <<EOF
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
EOF

echo "Waiting for AWX Operator to become ready..."
sudo kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=awx-operator \
  -n awx \
  --timeout=900s

sudo kubectl apply -f awx-demo.yml -n awx


echo "Waiting for AWX pods to become ready..."
sudo kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/managed-by=awx-operator \
  -n awx \
  --timeout=1800s

sudo kubectl get pods -n awx
sudo kubectl get svc -n awx
sudo kubectl get secret awx-admin-password -n awx -o jsonpath="{.data.password}" | base64 -d
echo
