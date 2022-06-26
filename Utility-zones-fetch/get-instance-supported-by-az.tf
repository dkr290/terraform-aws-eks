data "aws_ec2_instance_type_offerings" "my_instance_type1" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = ["eu-central-1a"]
  }

  location_type = "availability-zone"
}

output "output_v1_1" {
    value = data.aws_ec2_instance_type_offerings.my_instance_type1.instance_types
}