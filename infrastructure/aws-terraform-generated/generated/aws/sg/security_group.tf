resource "aws_security_group" "tfer--default_sg-038f3d4e42f32b15b" {
  description = "default VPC security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name   = "default"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-cluster-sg-microservices-container-grouping-757149350_sg-04fcb2519505c9a5b" {
  description = "EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name = "eks-cluster-sg-microservices-container-grouping-757149350"

  tags = {
    Name                                                     = "eks-cluster-sg-microservices-container-grouping-757149350"
    "kubernetes.io/cluster/microservices-container-grouping" = "owned"
  }

  tags_all = {
    Name                                                     = "eks-cluster-sg-microservices-container-grouping-757149350"
    "kubernetes.io/cluster/microservices-container-grouping" = "owned"
  }

  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31" {
  description = "EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30001"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30001"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30002"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30002"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30101"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30101"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30102"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30102"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30103"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30103"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30104"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30104"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30105"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30105"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30106"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30106"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30107"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30107"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30108"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30108"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30201"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30201"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30202"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30202"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30203"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30203"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30204"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30204"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30205"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30205"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30206"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30206"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30207"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30207"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30208"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30208"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30301"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30301"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30303"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30303"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30304"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30304"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30306"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30518"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30518"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31090"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31090"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31300"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31300"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31601"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31601"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "32723"
    protocol    = "tcp"
    self        = "false"
    to_port     = "32723"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8080"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8080"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8081"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8081"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8082"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8082"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8083"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8083"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "9411"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9411"
  }

  name = "eks-cluster-sg-microservices-grouping-cluster-588055163"

  tags = {
    Name                                                   = "eks-cluster-sg-microservices-grouping-cluster-588055163"
    "kubernetes.io/cluster/microservices-grouping-cluster" = "owned"
  }

  tags_all = {
    Name                                                   = "eks-cluster-sg-microservices-grouping-cluster-588055163"
    "kubernetes.io/cluster/microservices-grouping-cluster" = "owned"
  }

  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-allinone_sg-03ef90fe3d1eb39ec" {
  description = "eks-microservices-container-grouping-allinone"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30101"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30101"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-allinone"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-benchmark_sg-0190bcce7e72cc63c" {
  description = "security group for access benchmark node"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30001"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30001"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-benchmark"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-by-dependencies_sg-0b2e001bb2a91a8f5" {
  description = "eks-microservices-container-grouping-by-dependencies"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30301"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30301"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-by-dependencies"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-by-stack_sg-009155310a9c34015" {
  description = "eks-microservices-container-grouping-by-stack"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30201"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30201"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-by-stack"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-loadtest_sg-0ed0f3d98622ccd1e" {
  description = "eks-microservices-container-grouping-loadtest"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8089"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8089"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-loadtest"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-microservices-container-grouping-monitoring_sg-0d1322b8a0560a461" {
  description = "eks-microservices-container-grouping-monitoring"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30518"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30518"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31090"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31090"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31300"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31300"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31601"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31601"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "32723"
    protocol    = "tcp"
    self        = "false"
    to_port     = "32723"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "9411"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9411"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "0"
  }

  name   = "eks-microservices-container-grouping-monitoring"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--eks-remoteAccess-a6c302e7-c8f4-7eef-e040-d2d3200b1230_sg-00a2a4350c6ad4a16" {
  description = "Security group for all nodes in the nodeGroup to allow SSH access"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "22"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--eks-cluster-sg-microservices-grouping-cluster-588055163_sg-021d715d29fbcdb31_id}"]
    self            = "false"
    to_port         = "22"
  }

  name = "eks-remoteAccess-a6c302e7-c8f4-7eef-e040-d2d3200b1230"

  tags = {
    eks                  = "load-test"
    "eks:nodegroup-name" = "load-test"
  }

  tags_all = {
    eks                  = "load-test"
    "eks:nodegroup-name" = "load-test"
  }

  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-1_sg-05c8121b1f7a1fddb" {
  description = "launch-wizard-1 created 2021-10-30T22:01:45.361-03:00"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "5432"
    protocol    = "tcp"
    self        = "false"
    to_port     = "5432"
  }

  name   = "launch-wizard-1"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-2_sg-03ecee22d4f4c264b" {
  description = "launch-wizard-2 created 2021-12-14T19:42:10.764-03:00"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "React"
    from_port   = "3000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3000"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8000"
  }

  ingress {
    cidr_blocks = ["177.33.207.224/32"]
    description = "Leonardo"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["179.232.122.186/32"]
    description = "Victor"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  name   = "launch-wizard-2"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-3_sg-05d7edc277575a5ab" {
  description = "launch-wizard-3 created 2022-02-11T15:25:12.799-03:00"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["45.233.48.83/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  name   = "launch-wizard-3"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-4_sg-0ffcaa8431e6564c3" {
  description = "launch-wizard-4 created 2022-02-11T17:31:53.456-03:00"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  name   = "launch-wizard-4"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-5_sg-0b37bd6013d9e51e0" {
  description = "launch-wizard-5 created 2022-06-09T12:54:05.672Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30001"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30001"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "30002"
    protocol    = "tcp"
    self        = "false"
    to_port     = "30002"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "31601"
    protocol    = "tcp"
    self        = "false"
    to_port     = "31601"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "9411"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9411"
  }

  name   = "launch-wizard-5"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--launch-wizard-6_sg-0ea6d76cd3731b645" {
  description = "launch-wizard-6 created 2022-08-18T21:41:56.498Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "1099"
    protocol    = "tcp"
    self        = "false"
    to_port     = "1099"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "50000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "50000"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "60000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "60000"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "1099"
    protocol    = "tcp"
    self        = "false"
    to_port     = "1099"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "50000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "50000"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "60000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "60000"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8090"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8090"
  }

  name   = "launch-wizard-6"
  vpc_id = "vpc-0f3fe466d0a9ccab0"
}

resource "aws_security_group" "tfer--provision-name-loadtest-seg_sg-05c41629ec6825b44" {
  description = "Allow inbound traffic for Jmeter"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "port 22"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name = "provision-name-loadtest-seg"

  tags = {
    Name = "provision-name-loadtest-seg"
  }

  tags_all = {
    Name = "provision-name-loadtest-seg"
  }

  vpc_id = "vpc-0f3fe466d0a9ccab0"
}
