output "aws_eks_cluster_tfer--microservices-container-grouping_id" {
  value = "${aws_eks_cluster.tfer--microservices-container-grouping.id}"
}

# output "aws_eks_node_group_tfer--all-in-one_id" {
#   value = "${aws_eks_node_group.tfer--all-in-one.id}"
# }

output "aws_eks_node_group_tfer--benchmark_id" {
  value = "${aws_eks_node_group.tfer--benchmark.id}"
}

# output "aws_eks_node_group_tfer--by-dependencies_id" {
#   value = "${aws_eks_node_group.tfer--by-dependencies.id}"
# }

# output "aws_eks_node_group_tfer--by-stack_id" {
#   value = "${aws_eks_node_group.tfer--by-stack.id}"
# }

# output "aws_eks_node_group_tfer--kubecost_id" {
#   value = "${aws_eks_node_group.tfer--kubecost.id}"
# }

# output "aws_eks_node_group_tfer--load-test_id" {
#   value = "${aws_eks_node_group.tfer--load-test.id}"
# }

# output "aws_eks_node_group_tfer--monitoring_id" {
#   value = "${aws_eks_node_group.tfer--monitoring.id}"
# }
