# creating iam role for cluster

resource "aws_iam_role" "demo" {
    name = "eks-cluster-demo-role"

    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# attaching policy to the iam role for the cluster
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.demo.name
}

# creating the cluster
resource "aws_eks_cluster" "firstcluster" {
    name = "firstcluster"
    role_arn = aws_iam_role.demo.arn 

    vpc_config {
        subnet_ids = [
            var.public_subnet_az1_id,
            var.public_subnet_az2_id,
            var.private_app_subnet_az1_id,
            var.private_app_subnet_az2_id
        ]
    }
    depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

# we can create another tf file called nodes.tf for below code
# creating iam role for nodes group
resource "aws_iam_role" "nodes" {
    name = "eks-node-group-role"

    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}

# attaching policy to the node role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.nodes.name
}

# attaching policy to the node role
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.nodes.name
}

# attaching policy to the node role
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.nodes.name
}

# create node group resource
resource "aws_eks_node_group" "private_nodes" {
    cluster_name = aws_eks_cluster.firstcluster.name
    node_group_name = "private-nodes"
    node_role_arn = aws_iam_role.nodes.arn 
    subnet_ids = [
        var.private_app_subnet_az1_id,
        var.private_app_subnet_az2_id
    ]

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.small"]

    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        role = "general"
    }

}