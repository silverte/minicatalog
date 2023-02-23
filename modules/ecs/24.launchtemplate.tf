##################################
# Create LaunchTemplate
##################################
#ecs 를 구성할 autoscaling group 을 위한 시작 구성 
resource "aws_launch_configuration" "launch_conf" {
	#name				= "lt-${var.servicetitle}-${var.environment}-ecs-instance"
	name_prefix			= "lt-${var.servicetitle}-${var.environment}-ecs-instance"
	image_id 			= data.aws_ami.ami_optimized_ecs.id 		# var.EC2_AMI  # "ami-073a0375a611be5fa"
	instance_type 		= var.ECS_Cluster_Info.instance_type

	iam_instance_profile= aws_iam_instance_profile.ecs_instance_profile.arn
	security_groups 	= [ aws_security_group.ecs_instance.id ] 	# [ "sg-07d39bed187043e32", "sg-0b5bce5a993788f86" ]
	#key_name 			= aws_key_pair.ecs_key_pair.key_name

	# ECS Instance - IMDSv2 적용
	metadata_options {
		http_endpoint               = "enabled"
		http_tokens                 = "required"
		http_put_response_hop_limit = 2
	}
	
	ebs_optimized		= false
	enable_monitoring	= true

	#templatefile("./templates/user-data.sh", {
	#  cluster_name = aws_ecs_cluster.cluster.name
	#})

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF

# user_data  = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"

# 	  user_data = <<EOF
# #!/bin/bash
# echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
# sudo systemctl stop ecs
# sudo systemctl start ecs
# EOF

	root_block_device {
		volume_type           	= "gp2"
		volume_size				= var.ECS_Cluster_Info.volume_size
		encrypted			  	= true
		delete_on_termination 	= true
	}

	#ebs_block_device {
	#	device_name				= "/dev/sdh"
	#	#snapshot_id			= "snap-0c79816f45b645170"		## 변수화 해라
	#	volume_type				= "gp2"
	#	volume_size				= var.ECS_Cluster_Info.volume_size
	#	encrypted			  	= true
	#	delete_on_termination	= true
	#}

	depends_on = [ aws_iam_instance_profile.ecs_instance_profile ]
}