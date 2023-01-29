module "cci" {
  source        = "./modules/cci"

  subnet        = "default-ru-central1-a"
  instance_name = "cci-module-test"
  hostname      = "cci-module-test"

  cores         = 4
  memory        = 4

  nat           = true
}

output "cci" {
  value         = module.cci
}
