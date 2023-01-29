locals {
  resource_zone_map   = {
    stage              = "ru-central1-c"
    prod               = "ru-central1-a"
  }

  instance_resources   = {
    stage              = {
      cores            = 2
      memory           = 2
    }
    prod               = {
      cores            = 4
      memory           = 4
    }
  }

  instance_count_map   = {
    stage              = 1
    prod               = 2
  }

  instances            = {
    stage              = {
      0                = 2
    }
    prod               = {
      0                = 4
      1                = 4
    }
  }

  vpc_subnet_map       = {
    stage              = ["10.10.20.0/24"]
    prod               = ["10.10.10.0/24"]
  }
}
