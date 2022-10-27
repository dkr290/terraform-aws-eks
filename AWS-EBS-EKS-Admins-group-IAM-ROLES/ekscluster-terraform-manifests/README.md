## Manual sterps are described here 

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


aws sts get-caller-identity
# Configure kubeconfig for kubectl
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
aws eks --region eu-central-1  update-kubeconfig --name <name>

# Verify Kubernetes Worker Nodes using kubectl
kubectl get nodes
kubectl get nodes -o wide


# Export AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo $ACCOUNT_ID

# IAM Trust Policy 
POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':root"},"Action":"sts:AssumeRole","Condition":{}}]}')



# Verify both values
echo ACCOUNT_ID=$ACCOUNT_ID
echo POLICY=$POLICY

# Create IAM Role
aws iam create-role \
  --role-name eks-admin-role \AWS 
  --description "Kubernetes administrator role (for AWS IAM Authenticator for Kubernetes)." \
  --assume-role-policy-document "$POLICY" \
  --output text \
  --query 'Role.Arn'

  # Create IAM Policy - EKS Full access
cd iam-files
aws iam put-role-policy --role-name eks-admin-role --policy-name eks-full-access-policy --policy-document file://eks-full-access-policy.json


# Create IAM User Groups
aws iam create-group --group-name eksadmins

# Verify AWS ACCOUNT_ID is set
echo $ACCOUNT_ID

# IAM Group Policy
ADMIN_GROUP_POLICY=$(echo -n '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAssumeOrganizationAccountRole",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':role/eks-admin-role"
    }
  ]
}')


# Verify Policy (if AWS Account Id replaced in policy)
echo $ADMIN_GROUP_POLICY

# Create Policy
aws iam put-group-policy \
--group-name eksadmins \
--policy-name eksadmins-group-policy \
--policy-document "$ADMIN_GROUP_POLICY"

# Verify aws-auth configmap
kubectl -n kube-system get configmap aws-auth -o yaml

# Edit aws-auth configmap
kubectl -n kube-system edit configmap aws-auth

# Replace ACCOUNT_ID and EKS-ADMIN-ROLE
    - rolearn: arn:aws:iam::<ACCOUNT_ID>:role/<EKS-ADMIN-ROLE>
      username: eks-admin
      groups:
        - system:masters


 
# Verify aws-auth configmap after making changes
kubectl -n kube-system get configmap aws-auth -o yaml


# sverification
kubectl -n kube-system get configmap aws-auth -o yaml

# Create IAM User
aws iam create-user --user-name eksuser01

# add user to the group
# Associate IAM User to IAM Group  eksadmins
aws iam add-user-to-group --group-name <GROUP> --user-name <USER>
aws iam add-user-to-group --group-name eksadmins --user-name eksuser01

# Set password for user
aws iam create-login-profile --user-name eksuser01 --password <some password> --no-password-reset-required


# Create Security Credentials for IAM User and make a note of them
aws iam create-access-key --user-name eksuser01


# To list all configuration data
aws configure list

# To list all your profile names
aws configure list-profiles

# Configure aws cli eksadmin1 Profile 
aws configure --profile eksuser01
AWS Access Key ID:
AWS Secret Access Key:
Default region: 
Default output format: json

# Get current user configured in AWS CLI
aws sts get-caller-identity

# Set default profile
export AWS_DEFAULT_PROFILE=eksuser01

# Get current user configured in AWS CLI
aws sts get-caller-identity

# Clean-Up kubeconfig
rm -rf  ~/.kube/config
$HOME/.kube/config
cat $HOME/.kube/config

# Configure kubeconfig for kubectl
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
aws eks --region eu-central-1 update-kubeconfig --name <name>
# Fail An error occurred (AccessDeniedException) when calling the DescribeCluster operation: User: // does not have permissions it is just for EKS 

