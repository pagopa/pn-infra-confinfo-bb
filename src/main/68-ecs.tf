#ECS
#############################

resource "aws_ecs_cluster" "EcsCluster" {
  name = "${var.pn_macro_service_name}-ecs-cluster"
}