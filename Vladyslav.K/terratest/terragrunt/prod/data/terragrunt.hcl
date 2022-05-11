include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::https://github.com/Vladkarok/terraform-aws-datainfo.git//?ref=main" 
}
inputs = {
  domain = "vladkarok.ml"
}