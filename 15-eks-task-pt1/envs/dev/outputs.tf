output "configure_kubectl" {
  value = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
}