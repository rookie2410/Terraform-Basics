variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo-eks"
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "EKS version"
  type        = string
  default     = "1.30"
}

variable "endpoint_private_access" {
  description = "Enable private API endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API endpoint access"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to access public EKS endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}