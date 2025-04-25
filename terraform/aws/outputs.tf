output "dynamodb_endpoint" {
  value       = "https://dynamodb.${data.aws_region.current.name}.amazonaws.com"
  description = "DynamoDB table endpoint"
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.users.name
  description = "Name of the DynamoDB table"
}

output "dynamodb_vpc_endpoint_id" {
  description = "The ID of the DynamoDB VPC endpoint"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for IRSA"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "eks_node_role_arn" {
  description = "The IAM role ARN for the EKS worker nodes"
  value       = aws_iam_role.eks_node_group_role.arn
}

output "backend_irsa_role_arn" {
  description = "The IAM role ARN assumed by the backend service account via IRSA"
  value       = aws_iam_role.backend_irsa.arn
  sensitive   = true
}
