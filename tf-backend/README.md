# tf-ansible-lab - Backend de Terraform y Ansible para AWS

## PREREQUISITO IMPORTANTE 
**ANTES DE CONFIGURAR CUALQUIER INFRAESTRUCTURA, SE RECOMIENDA CONFIGURAR EL BACKEND DE TERRAFORM**

### ¿Por qué es un prerequisito?

1. **Gestión del Estado**: Terraform necesita almacenar el estado de la infraestructura en un lugar seguro y accesible
2. **Bloqueo de Estado**: Previene modificaciones concurrentes que podrían corromper el estado
3. **Colaboración**: Permite que múltiples desarrolladores trabajen en la misma infraestructura
4. **Versionado**: Mantiene historial de cambios del estado
5. **Seguridad**: Encripta el estado y lo almacena de forma segura

### Configuración del Backend

El backend utiliza:
- **S3**: Para almacenar el archivo de estado de Terraform
- **DynamoDB**: Para el bloqueo del estado (prevenir modificaciones concurrentes)

### Configuración Actual

```hcl
terraform {
  backend "s3" {
    bucket         = "tf-ansible-cloudlabs"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-ansible-cloudlabs-state-lock"
    profile        = "cloudlabs"
    encrypt        = true
  }
}
```

### Pasos para Configurar el Backend

1. **Verificar perfil AWS**:
   ```bash
   aws configure list-profiles
   aws sts get-caller-identity --profile cloudlabs
   ```

2. **Crear recursos del backend usando Terraform** (ejecutar una sola vez):
   
   Navegar al directorio del backend:
   ```bash
   cd tf-backend/
   ```

   Ejecutar comandos de Terraform:
   ```bash
   # Inicializar Terraform
   terraform init
   
   # Validar configuración
   terraform validate
   
   # Planear cambios
   terraform plan
   
   # Aplicar cambios (crear S3 bucket y tabla DynamoDB)
   terraform apply
   ```

   > **Nota**: El directorio `tf-backend/` debe contener la configuración de Terraform para crear el bucket S3 y la tabla DynamoDB necesarios para el backend.

### Verificación del Backend

```bash
# Verificar que el bucket existe
aws s3 ls s3://tf-ansible-cloudlabs --profile cloudlabs

# Verificar que la tabla DynamoDB existe
aws dynamodb describe-table --table-name tf-ansible-cloudlabs-state-lock --profile cloudlabs

# O verificar con terraform (desde el directorio tf-backend)
cd tf-backend/
terraform output
```


### IMPORTANTE

- **NO ELIMINAR** el bucket S3 ni la tabla DynamoDB una vez que contengan estado
- **HACER BACKUP** del estado antes de realizar cambios críticos
- **VERIFICAR** que el backend esté funcionando antes de aplicar cambios

### Variables de Configuración

Las variables están definidas en `terraform.tfvars`:

```hcl
aws_profile          = "cloudlabs"
aws_region          = "us-east-1"
bucket_name         = "tf-ansible-cloudlabs"
dynamodb_table_name = "tf-ansible-cloudlabs-state-lock"
environment         = "dev"
```

---

## Configuración de Infraestructura

Una vez configurado el backend, puedes proceder con la configuración de la infraestructura...


## Backend Recomendado en Recursos AWS
``````hcl
terraform {
  required_version = ">= 1.12"
  
  backend "s3" {
    bucket         = "tf-ansible-cloudlabs"
    key            = "tf-recurso.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-ansible-cloudlabs-state-lock"
    profile        = "cloudlabs"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2"
    }
  }
}

provider "aws" {
  profile = "cloudlabs"
  region  = "us-east-1"
}