##################################
# initialize local vars for EKS from module.network.out_snets_info
##################################
locals {

	all_snets_cidr_block = {
		for key, value in var.out_snets_info : key => value.cidr_block
	}

	all_snets_CIDRs = values(local.all_snets_cidr_block)  # Type : set

	ecs_instance_snets_id = {
		for key, value in var.out_snets_info : key => value.id
			if contains( var.ECS_Inst_Subnets, key )
	}

	ecs_instance_snet_IDs = values(local.ecs_instance_snets_id)  # Type : set

	ecs_instance_snets_cidr_block = {
		for key, value in var.out_snets_info : key => value.cidr_block
			if contains( var.ECS_Inst_Subnets, key )
	}

	ecs_instance_snet_CIDRs = values(local.ecs_instance_snets_cidr_block)  # Type : set

	ecs_lb_snets_id = {
		for key, value in var.out_snets_info : key => value.id
			if contains( var.ECS_LB_Subnets, key )
	}
	
	ecs_lb_snets_IDs = values(local.ecs_lb_snets_id)  # Type : set

	dbms_snets_cidr_block = {
		for key, value in var.out_snets_info : key => value.cidr_block
			if contains( var.DBMS_Inst_Subnets, key )
	}
	
	dbms_snets_CIDRs = values(local.dbms_snets_cidr_block)  # Type : set
}

output "ecs_instance_snet_IDs" {
	value 		= local.ecs_instance_snet_IDs
}

output "ecs_instance_snet_CIDRs" {
	value 		= local.ecs_instance_snet_CIDRs
}

output "ecs_lb_snets_IDs" {
	value 		= local.ecs_lb_snets_IDs
}



#output "ecs_instance_snet_map" {
#	value 		= local.ecs_instance_snet_map
#}

##################################
# Add-On 추가해야한다. ( 2022-05-02 )
##################################
# [완료] aws-load-balancer-controller ( IAM Role w/oidc, IAM Policy, serviceaccount, helm chart )

# [해라] veleo ( w/S3 Bucket )
# [해라] aws-efs-csi-driver ( w/EFS Filesystem )
# [해라] configure aws-auth & kubernetes role ( for Datadog, Istio )

# [제외] aws-ebs-csi-driver
