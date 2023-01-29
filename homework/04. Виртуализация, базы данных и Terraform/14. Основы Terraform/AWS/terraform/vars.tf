locals {
  instance_type_map   = {
    stage             = "t3.nano"
    prod              = "t3.micro"
  }

  instance_count_map  = {
    stage             = 1
    prod              = 2
  }

  instances           = {
    stage             = {
      0               = "t3.nano"
    }
    prod              = {
      0               = "t3.micro"
      1               = "t3.micro"
    }
  }
}
