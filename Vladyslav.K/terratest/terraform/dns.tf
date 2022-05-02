# data "aws_route53_zone" "primary" {
#   name = var.domain
# }
# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "2.0"
#   #zone_name = data.aws_route53_zone.primary.name
#   zone_id    = data.aws_route53_zone.primary.zone_id
#   depends_on = [module.ec2_instance, module.alb, module.vpc, module.asg]
#   records = jsonencode([
#     {
#       name = "dbgeo"
#       type = "A"
#       ttl  = 3600
#       records = [
#         module.ec2_instance.private_ip,
#       ]
#     },
#     {
#       name    = "geocitizen"
#       type    = "A"
#       zone_id = data.aws_route53_zone.primary.zone_id
#       alias = {
#         name    = module.alb.lb_dns_name
#         zone_id = data.aws_route53_zone.primary.zone_id
#       }
#     }
#   ])


# }
