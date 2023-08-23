resource "aws_eks_cluster" "tfer--microservices-container-grouping" {
  #enabled_cluster_log_types = ["api", "audit", "controllerManager"]
  tags = {
    "User"       = "FernandoHenriqueBuzato"
    "experiment" = "microservices-grouping"
  }
  tags_all = {
    "User"       = "FernandoHenriqueBuzato"
    "experiment" = "microservices-grouping"
  }
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  name     = "microservices-container-grouping"
  role_arn = "arn:aws:iam::380285632927:role/prod-usp-icmc20220415185049499400000003"
  version  = "1.23"

  vpc_config {
    endpoint_private_access = "false"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    subnet_ids              = ["subnet-0312ec158c3ce9da3", "subnet-036215055911f9bd3", "subnet-07c048f336b37d2ef"]
  }
}
