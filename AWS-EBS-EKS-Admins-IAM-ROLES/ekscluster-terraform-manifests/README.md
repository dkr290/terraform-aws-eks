1. Create EKS Cluster bu executing the terraform
a. EKs
b. Public node Group
c. Private node group
## Install Kubectl
aws eks --region <<region>> update-kubeconfig --name <<cluster_name>>


# Verify Kubernetes Worker Nodes using kubectl
kubectl get nodes
kubectl get nodes -o wide

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

# EKS OpenID Connect Well Known Configuration URL
<EKS OpenID Connect provider URL>/.well-known/openid-configuration



### create the adminuser
aws sts get-caller-identity
# Create IAM User
aws iam create-user --user-name eksadmin1

# Attach AdministratorAccess Policy to User
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name eksadmin1

# Set password for eksadmin1 user
aws iam create-login-profile --user-name eksadmin1 --password xxxxxxxx --no-password-reset-required

# Create Security Credentials for IAM User and make a note of them
aws iam create-access-key --user-name eksadmin1

# Make a note of Access Key ID and Secret Access Key
User: eksadmin1
{
    "AccessKey": {
        "UserName": "eksadmin1",
        "AccessKeyId": "xxxxxxx",
        "Status": "Active",
        "SecretAccessKey": "xxxxxxxxxx",
        "CreateDate": "xxxxxxx"
    }
}


# To list all configuration data
aws configure list

# To list all your profile names
aws configure list-profiles

# Configure aws cli eksadmin1 Profile 
aws configure --profile eksadmin1


# Get current user configured in AWS CLI
aws sts get-caller-identity

# Configure kubeconfig for eksadmin1 AWS CLI profile
aws eks --region eu-central-1 update-kubeconfig --name <eks-cluster> --profile eksadmin1


# Verify kubeconfig file
cat $HOME/.kube/config
      env:
      - name: AWS_PROFILE
        value: eksadmin1
Observation: At the end of kubeconfig file we find that AWS_PROFILE it is using is "eksadmin1" profile   

# Verify Kubernetes Nodes
kubectl get nodes
Observation: 
1. We should fail in accessing the EKS Cluster resources using kubectl

# to switch the profiles


aws eks --region eu-central-1 update-kubeconfig --name <eks cluster> --profile default

# Verify kubeconfig file
cat $HOME/.kube/config
      env:
      - name: AWS_PROFILE
        value: default

# Verify aws-auth config map before making changes
kubectl -n kube-system get configmap aws-auth -o yaml


# Get IAM User and make a note of arn
aws iam get-user --user-name eksadmin1


# To edit configmap
kubectl -n kube-system edit configmap aws-auth 

## mapUsers TEMPLATE (Add this under "data")
  mapUsers: |
    - userarn: <REPLACE WITH USER ARN>
      username: admin
      groups:
        - system:masters

#####  CREATE A BASIC USER WITHOUT aws ADMIN TO BE ONLY EKS ADMIN

# Get current user configured in AWS CLI
aws sts get-caller-identity
Observation: Should see the user "your username" from "default" profile

# Create IAM User
aws iam create-user --user-name eksadmin2

# Set password for eksadmin1 user
aws iam create-login-profile --user-name eksadmin2 --password <password here> --no-password-reset-required

# Create Security Credentials for IAM User and make a note of them
aws iam create-access-key --user-name eksadmin2

# Make a note of Access Key ID and Secret Access Key
User: eksadmin2
{
    "AccessKey": {
        "UserName": "eksadmin2",
        "AccessKeyId": "xxxxxxxxxxxxxx",
        "Status": "Active",
        "SecretAccessKey": "xxxxxxxxxxxxxxxxx",
        "CreateDate": "xxxxxxxxxxxxxxxxxxx"
    }
}
 - We already know from previous demo that aws-auth should be configured with user details to work via kubectl.
 - So we will test kubectl access after updating the eks configmap aws-auth

aws sts get-caller-identity
Observation:
1. We can update aws-auth configmap using "eksadmin2" user or cluster creator user <some user>

# Get IAM User and make a note of arn
aws iam get-user --user-name eksadmin2

# To edit configmap
kubectl -n kube-system edit configmap aws-auth

## mapUsers TEMPLATE (Add this under "data")
  mapUsers: |
    - userarn: <REPLACE WITH USER ARN>
      username: admin
      groups:
        - system:masters

## mapUsers TEMPLATE - Replaced with IAM User ARN
  mapUsers: |
    - userarn: xxxxxxxxxxxxxxxxxxxx
      username: eksadmin1
      groups:
        - system:masters     
    - userarn: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      username: eksadmin2
      groups:
        - system:masters              

# Verify Nodes if they are ready (only if any errors occured during update)
kubectl get nodes --watch

# Verify aws-auth config map after making changes
kubectl -n kube-system get configmap aws-auth -o yaml

# To list all configuration data
aws configure list

# To list all your profile names
aws configure list-profiles

# Configure aws cli eksadmin1 Profile 
aws configure --profile eksadmin2

# To list all your profile names
aws configure list-profiles

# Get current user configured in AWS CLI
aws sts get-caller-identity


# Configure kubeconfig for kubectl with AWS CLI Profile eksadmin2
aws eks --region <region-code> update-kubeconfig --name <cluster_name> --profile <AWS-CLI-Profile-NAME>

fail for eksadmin2

# Get current user configured in AWS CLI
aws sts get-caller-identity
Observation: Should see the user <user account> (EKS_Cluster_Create_User) from default profile

# Create IAM Policy
cd iam-files
aws iam create-policy --policy-name eks-full-access-policy --policy-document file://eks-full-access-policy.json



# Attach Policy to eksadmin2 user (Update ACCOUNT-ID and Username)
aws iam attach-user-policy --policy-arn <POLICY-ARN> --user-name <USER-NAME>
aws iam attach-user-policy --policy-arn arn:aws:iam::xxxxxxxxxxxxxx:policy/eks-full-access-policy --user-name eksadmin2


# Access EKS with the user eksadmin2 but through GUI console
# kubectl with eksadmin2 context


Update depends_on Meta-Argument with configmap kubernetes_config_map_v1.aws_auth.
When EKS Cluster is created, kubernetes object aws-auth configmap will not get created
aws-auth configmap will be created when the first EKS Node Group gets created to update the EKS Nodes related role information in aws-auth configmap.
So we will populate the equivalent aws-auth configmap before creating the EKS Node Group and also we will create EKS Node Group only after configMap aws-auth resource is created. This is to avoid bad errors with the configmap
