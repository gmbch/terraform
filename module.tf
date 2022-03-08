resource "aws_ecr_repository" "overview-dashes" {
	name = "overview-dashes"
}

resource "aws_ecs_cluster" "cron-jobs" {
	name = "cron-jobs"
}

module "cron_job" {
  source = "git::https://github.com/gmbch/terraform.git"

  ecr_repo_name                  ="force-overview-dashboards"

  image_tag                      = "latest"

  ecs_cluster_name               = "cron-jobs"

  task_name                      = "mv-analysis-cath-max"

  subnet_ids                     = "subnet-053bd4cd306e11350"

  task_role_arn                  = "arn:aws:iam::888861447612:role/force-tab-over-sm"

  cloudwatch_schedule_expression = "cron(0 0/1 ? * MON-FRI *)"

}

resource "aws_sns_topic_subscription" "task_failure" {

  topic_arn = module.cron_job.sns_topic_arn

  protocol	= "email"

  endpoint 	= "gabriel.miller@childrens.harvard.edu"

}