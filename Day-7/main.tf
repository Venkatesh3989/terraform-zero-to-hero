provider "aws" {
  region = "us-east-2"
}

provider "vault" {
  address = "http://18.191.191.145:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "032c5faa-186f-6fca-fb2b-d1e832f72efb"
      secret_id = "47e8a32b-c25c-019f-25f3-1ef697078304"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv-1" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"

  tags = {
    Secret = data.vault_kv_secret_v2.example.data["admin"]
  }
}
