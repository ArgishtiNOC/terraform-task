resource "aws_iam_role" "task4_role" {
  name = "task4"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "task4_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.task4_role.name
}

resource "aws_iam_role_policy_attachment" "task4_1_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.task4_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "profile"
  role = aws_iam_role.task4_role.name
}