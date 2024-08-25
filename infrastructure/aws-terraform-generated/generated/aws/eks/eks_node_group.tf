resource "aws_eks_node_group" "tfer--all-in-one" {
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
  disk_size      = "50"
  instance_types = ["t3.xlarge"]

  labels = {
    namespace = "all-in-one"
  }

  node_group_name = "all-in-one"
  node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
  # release_version = "1.22.17-20230513"

  scaling_config {
    desired_size = "1"
    max_size     = "1"
    min_size     = "1"
  }

  subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

  taint {
    effect = "NO_SCHEDULE"
    key    = "namespace"
    value  = "all-in-one"
  }

  update_config {
    max_unavailable = "1"
  }

  version = "1.23"
}

# resource "aws_eks_node_group" "tfer--benchmark" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "50"
#   instance_types = ["t3.xlarge"]

#   labels = {
#     namespace = "benchmark"
#   }

#   node_group_name = "benchmark"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   # release_version = "1.22.17-20230513"

#   scaling_config {
#     desired_size = "2"
#     max_size     = "2"
#     min_size     = "2"
#   }

#   subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "benchmark"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.23"
# }

# resource "aws_eks_node_group" "tfer--by-dependencies" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "50"
#   instance_types = ["t3.xlarge"]

#   labels = {
#     namespace = "by-dependencies"
#   }

#   node_group_name = "by-dependencies"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   # release_version = "1.22.17-20230513"

#   scaling_config {
#     desired_size = "2"
#     max_size     = "2"
#     min_size     = "2"
#   }

#   subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "by-dependencies"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.23"
# }

# resource "aws_eks_node_group" "tfer--by-stack" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "50"
#   instance_types = ["t3.xlarge"]

#   labels = {
#     namespace = "by-stack"
#   }

#   node_group_name = "by-stack"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   # release_version = "1.22.17-20230513"

#   scaling_config {
#     desired_size = "2"
#     max_size     = "2"
#     min_size     = "2"
#   }

#   subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "by-stack"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.23"
# }

resource "aws_eks_node_group" "tfer--kubecost" {
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  cluster_name    = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
  disk_size       = "20"
  instance_types  = ["t3.medium"]
  node_group_name = "kubecost"
  node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
  # release_version = "1.22.17-20230513"

  scaling_config {
    desired_size = "1"
    max_size     = "1"
    min_size     = "1"
  }

  subnet_ids = ["subnet-036215055911f9bd3"]

  update_config {
    max_unavailable = "1"
  }

  version = "1.23"
}

# resource "aws_eks_node_group" "tfer--load-test" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "20"
#   instance_types = ["c5.2xlarge"]

#   labels = {
#     namespace = "load-test"
#   }

#   node_group_name = "load-test"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   # release_version = "1.22.17-20230513"

#   remote_access {
#     ec2_ssh_key               = "MICROSERVICES-CONTAINER-GROUPING"
#     source_security_group_ids = ["sg-021d715d29fbcdb31","sg-0ed0f3d98622ccd1e"]
#   }

#   scaling_config {
#     desired_size = "1"
#     max_size     = "1"
#     min_size     = "1"
#   }

#   subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "load-test"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.23"
# }

# resource "aws_eks_node_group" "tfer--monitoring" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "20"
#   instance_types = ["t3.medium"]

#   labels = {
#     namespace = "monitoring"
#   }

#   node_group_name = "monitoring"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   # release_version = "1.22.17-20230513"

#   scaling_config {
#     desired_size = "1"
#     max_size     = "1"
#     min_size     = "1"
#   }

#   #subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]
#   subnet_ids = ["subnet-036215055911f9bd3"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "monitoring"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.23"
# }

# resource "aws_eks_node_group" "tfer--logging" {
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#   cluster_name   = "${aws_eks_cluster.tfer--microservices-container-grouping.name}"
#   disk_size      = "20"
#   instance_types = ["t3.xlarge"]

#   labels = {
#     namespace = "logging"
#   }

#   node_group_name = "logging"
#   node_role_arn   = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415190108421000000009"
#   release_version = "1.22.17-20230513"

#   scaling_config {
#     desired_size = "1"
#     max_size     = "1"
#     min_size     = "1"
#   }

#   subnet_ids = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]

#   taint {
#     effect = "NO_SCHEDULE"
#     key    = "namespace"
#     value  = "logging"
#   }

#   update_config {
#     max_unavailable = "1"
#   }

#   version = "1.22"
# }