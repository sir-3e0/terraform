# variable "users" {
#     type = list
#     default = ["alice", "bob", "john"]
# }

# resource "aws_iam_user" "ewi" {
#     name = var.users[count.index]
#     count = 3
# }