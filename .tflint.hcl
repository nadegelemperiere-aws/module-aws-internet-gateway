plugin "aws" {
    enabled = true
    version = "0.28.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Multiple targets are mutually exclusive, so this is a false alarm
rule "aws_route_specified_multiple_targets" {
  enabled = false
}
