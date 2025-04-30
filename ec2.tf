# resource "aws_instance" "myec2" {
#   ami           = "ami-0cb91c7de36eed2cb"
#   instance_type = "t2.micro"
#   count         = 3
#   tags = {
#     Name = "payment-system-${count.index}"
#   }
# }

# resource "aws_iam_user" "ewi" {
#   name  = "payments-user-${count.index}"
#   count = 3
# }
