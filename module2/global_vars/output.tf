# Default tags
output "default_tags" {
  value = {
    "Owner" = "Group13"
    "App"   = "Project"
  }
}

# Prefix to identify resources
output "prefix" {
  value     = "prod_Environment"
}