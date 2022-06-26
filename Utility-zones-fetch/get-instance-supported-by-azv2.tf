data "aws_ec2_instance_type_offerings" "my_instance_type2" {

  for_each = toset(["eu-central-1a","eu-central-1b","eu-central-1c"])
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

output "output_v2_1" {
    value = toset([for t in data.aws_ec2_instance_type_offerings.my_instance_type2: t.instance_types])
}


output "output_v2_2" {
    value = {for az, instance in data.aws_ec2_instance_type_offerings.my_instance_type2: az => instance.instance_types}
}