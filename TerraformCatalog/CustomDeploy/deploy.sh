#!/bin/bash

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

set -e # exit on error
trap 'catch $? $LINENO' EXIT

catch() {
    if [ "$1" != "0" ]; then
        # attempt to notify our provided user
        echo -e "Subject: Deployment encountered an error.\n\nAn error was encountered when attempting to deploy. Exit code $1 was returned from line #$2." | ssmtp $notify
    fi
}

trace() {
    echo -e "\n>>> $@ ...\n"
}

readonly EnvironmentState="$ACTION_STORAGE/environment.tfstate"
readonly EnvironmentPlan="$ACTION_TEMP/environment.tfplan"
readonly EnvironmentVars="$ACTION_TEMP/environment.tfvars.json"

echo "$ACTION_PARAMETERS" > $EnvironmentVars
echo "Special deploy script."

echo "Fetching email password from Key Vault"
authPass=$(az keyvault secret show --name "email-password" --vault-name "kv-jarewert-01" --query "value" -o tsv)

trace "Installing mail client"
apk add ssmtp

notify=$(echo $ACTION_PARAMETERS | jq -r '."notification-email"')

echo "UseTLS=YES
FromLineOverride=YES
mailhub=smtp.gmail.com:465
root=adedeployment@gmail.com
AuthUser=adedeployment@gmail.com
AuthPass=$authPass" > /etc/ssmtp/ssmtp.conf

trace "Terraform Info"
terraform -version

trace "Initializing Terraform"
terraform init -no-color

trace "Creating Terraform Plan"
terraform plan -no-color -compact-warnings -refresh=true -lock=true -state=$EnvironmentState -out=$EnvironmentPlan -var-file="$EnvironmentVars" -var "resource_group_name=$ENVIRONMENT_RESOURCE_GROUP_NAME"

trace "Applying Terraform Plan"
terraform apply -no-color -compact-warnings -auto-approve -lock=true -state=$EnvironmentState $EnvironmentPlan

trace "Notifying deployment owner"
echo -e "Subject: Deployment completed successfully.\n\nThe Azure Deployments Environment was created successfully." | ssmtp $notify