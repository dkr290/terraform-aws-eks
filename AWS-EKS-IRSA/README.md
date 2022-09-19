1. Create EKS Cluster bu executing the terraform
a. EKs
b. Public node Group
c. Private node group
## Install Kubectl
aws eks --region <<region>> update-kubeconfig --name <<cluster_name>>

kubectl get nodes
kubectl get nodes -o wide
kubectl get svc


## Connect to Bastion host and then to worker nodes

ssh -i private-key/theprivatekey.pem ec2-user@Bastion-Host-public-ip-address
its possible for the public node group to use public ip for the worker node

ssh /tmp/key.pem ec2-user@Private_nodegroup_private_ip

# verify kubelet and kube proxy are running
ps -ef | grep kube
# verify kubelet-config.json
cat /etc/kubernetes/kubelet/kubelet-config.json
# verify kubelet kubeconfig
cat /var/lib/kubelet/kubeconfig

wget <EKS CLusteAPI endpoint> to verify especially for the private workers can go through nat gateway and connect

