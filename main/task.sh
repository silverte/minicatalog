#!/bin/bash

aws ecs register-task-definition --cli-input-json file://./main/json/task-definition-planner.json;
aws ecs register-task-definition --cli-input-json file://./main/json/task-definition-manager.json;