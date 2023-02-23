# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "ami_optimized_ecs" {
    most_recent = true
    owners      = ["amazon"]  # AWS  # TestBed 05599 - "592806604814"
    #owners      = ["self"] # AWS -  (the current account)

    filter {
        name   = "name"
        #values = ["amzn-ami*amazon-ecs-optimized"]
        values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
        # values = ["amzn2-ami-ecs-hvm-2.0.20220421-x86_64-ebs"]
        # values = ["amzn-ami*amazon-ecs-optimized"]        
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}