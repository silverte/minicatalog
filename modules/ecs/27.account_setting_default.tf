############################################################################################################
# set aws vpc trunking 
############################################################################################################

resource "aws_ecs_account_setting_default" "ecs_account_setting" {
    name = "awsvpcTrunking"
    value = "enabled"
}
