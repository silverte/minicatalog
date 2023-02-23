#!/bin/bash

aws ecs register-task-definition --cli-input-json file://json/task-definition-planner.json;
aws ecs register-task-definition --cli-input-json file://json/task-definition-manager.json;