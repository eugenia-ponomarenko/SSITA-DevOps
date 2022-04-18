resource "aws_iam_role" "GeoCit_Role" {
  name = local.iam_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = local.iam_policy_att_name
  roles      = ["${aws_iam_role.GeoCit_Role.name}"]
  policy_arn = local.policy_arn
}

resource "aws_iam_instance_profile" "geocit_profile" {
  name = local.iam_instance_profile_name
  role = aws_iam_role.GeoCit_Role.name
}
