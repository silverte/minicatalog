

resource "aws_flow_log" "vpc_flowlog" {

  count  = var.vpc_information.vpc_flowlog_arn != "" ? 1 : 0

  log_destination = var.vpc_information.vpc_flowlog_arn
  log_destination_type = "s3"
  log_format = "$${action} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${srcaddr} $${srcport} $${start} $${tcp-flags} $${traffic-path} $${vpc-id}"
  traffic_type = "ALL"
  vpc_id = aws_vpc.default_vpc.id
  max_aggregation_interval = "600"

destination_options {
  file_format = "parquet"
  hive_compatible_partitions = false
  per_hour_partition = true
  }
  
  depends_on  = [aws_vpc.default_vpc]
}