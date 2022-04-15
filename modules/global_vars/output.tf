# Default tags
output "default_tags" {
  value = {
    "Owner" = "Group13-Dev"
    "App"   = "Project"
  }
}

# Prefix to identify resources
output "prefix" {
  value     = "Dev_Environment"
}