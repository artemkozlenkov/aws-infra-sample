include {
  path = find_in_parent_folders()
}
terraform{
  after_hook "backup_tfstate" {
    commands     = ["plan"]
    execute      = ["/bin/bash", "-c", "export AWS_PROFILE=artem && terraform state pull > terraform.tfstate.backup"]
  }
}
