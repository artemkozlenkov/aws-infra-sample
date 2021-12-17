output "rds_endpoint" {
  value = module.rds-aurora_mysql.cluster_endpoint
}

output "master_password" {
  value     = module.rds-aurora_mysql.cluster_master_password
  sensitive = true
}

output "master_username" {
  value     = module.rds-aurora_mysql.cluster_master_username
  sensitive = true
}
aisin
