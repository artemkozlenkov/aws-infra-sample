include {
  path = find_in_parent_folders()
} 
terraform{
  after_hook "backup_tfstate" {
    commands     = ["apply"]
    execute      = ["/bin/bash", "-c", "export AWS_PROFILE=artem && terraform state pull > terraform.tfstate.backup.json"]
  }
}