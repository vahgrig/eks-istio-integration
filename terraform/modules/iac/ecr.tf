resource "aws_ecr_repository" "ecr_repos" {
  for_each             = toset(var.repositorys)
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(
    { Environment = "${var.project_name}" },
    var.tags
  )
}