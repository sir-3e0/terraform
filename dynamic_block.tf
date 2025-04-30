# variable "sg_ports" {
#     type = list(number)
#     default = [22, 8200, 8201, 8300, 9500]
# }

# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = file("~/.ssh/id_ed25519.pub")
# }

# resource "aws_security_group" "dynamic_sg" {
#     name = "dynamic_sg"
#     description = "Ingress for vault"
#     dynamic "ingress" {
#         for_each = var.sg_ports
#         iterator = port
#         content {
#             from_port = port.value
#             to_port = port.value
#             protocol = "tcp"
#             cidr_blocks = ["0.0.0.0/0"]
#         }
#     }

# }