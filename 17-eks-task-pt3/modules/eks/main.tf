# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29"

vpc_config {
    subnet_ids = var.private_subnet_ids 

    endpoint_private_access = true
    endpoint_public_access  = false 
  }
access_config {
  authentication_mode = "API_AND_CONFIG_MAP"
  bootstrap_cluster_creator_admin_permissions = true
}
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_registry_policy,
  ]
}

resource "aws_eks_access_entry" "bastion_admin" {
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = var.bastion_role_arn       
  type              = "STANDARD"
}
resource "aws_eks_access_policy_association" "bastion_policy" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.bastion_role_arn

  access_scope {
    type = "cluster"
  }
  
  depends_on = [aws_eks_access_entry.bastion_admin]
}

# Allow HTTPS access from Bastion to EKS Cluster SG
resource "aws_security_group_rule" "allow_bastion_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id # Automatyczna SG klastra
  source_security_group_id = var.bastion_security_group_id
  description              = "Allow HTTPS from Bastion"
}



# Allows HTTP access from Bastion to EKS Cluster SG
resource "aws_security_group_rule" "allow_bastion_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.bastion_security_group_id
  description              = "Allow HTTP from Bastion"
}