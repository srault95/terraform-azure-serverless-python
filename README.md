## Exemple d'Azure Function Python et déploiement avec Terraform

### Requirements

- Python 3.7+
- [Terraform](https://www.terraform.io/downloads.html)
- [Az cli](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- Une souscription Azure avec des droits d'administration
- Un resource group déjà créé [doc](https://docs.microsoft.com/fr-fr/azure/azure-resource-manager/management/manage-resource-groups-cli)

### Déploiement

```bash

# ou az login -u xxx
az login

cd terraform

# Adaptez le nom du ressource GROUP et l'ID de souscription
export AZURE_RESOURCE_GROUP=my-resourcegroup
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"

# Vérifiez que la variable app_function_name dans terraform/terraform.tfvars:
export FUNCTION_APP_NAME=my-function-app

# Créez un compte de service avec un scope sur le ressource groupe d'installation
# Pensez à sauvegarder les valeurs du client ID et secret
AZURE_ACCOUNT=$(az ad sp create-for-rbac -n "Myapp" --role contributor --scopes /subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP)
export ARM_CLIENT_ID="$(echo $AZURE_ACCOUNT | jq -j .appId)"
export ARM_CLIENT_SECRET="$(echo $AZURE_ACCOUNT | jq -j .password)"
export ARM_TENANT_ID="$(echo $AZURE_ACCOUNT | jq -j .tenant)"

terraform init
terraform plan
terraform apply

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az account set -s $ARM_SUBSCRIPTION_ID
```

**Pour récupérer la clé d'API:**

```bash
API_KEY=$(az rest --method post --uri /subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP/providers/Microsoft.Web/sites/$FUNCTION_APP_NAME/host/default/listKeys?api-version=2018-11-01 --query functionKeys.default -o tsv)

# L'url d'accès à la fonction idefix sera:
echo "https://$FUNCTION_APP_NAME.azurewebsites.net/api/idefix?code=$API_KEY"
# ou
API_HOSTNAME=$(az rest --method get --uri /subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP/providers/Microsoft.Web/sites/$FUNCTION_APP_NAME?api-version=2018-11-01 --query properties.defaultHostName -o tsv)
echo "https://$API_HOSTNAME/api/idefix?code=$API_KEY"
```

**Déploiement de l'application:**

```bash
cd ..

# Par Git:
#git remote add azure https://$FUNCTION_APP_NAME.scm.azurewebsites.net/$FUNCTION_APP_NAME.git
#git push azure master

# Par azure-functions-core-tools
# Nécessite l'application azure-functions-core-tools: sudo apt-get install azure-functions-core-tools-3
func azure functionapp publish $FUNCTION_APP_NAME
```

