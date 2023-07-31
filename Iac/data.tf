data "aws_eks_cluster" "dev-cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "dev-cluster" {
  name = module.eks.cluster_name
}