# tf-ansible-lab

Este reto implementa una infraestructura base en AWS utilizando Terraform para el aprovisionamiento de recursos y Ansible para la configuración de servidores. incluye la creación de una VPC con subredes públicas y privadas, instancias EC2 y la configuración automatizada de servicios.

## 📋 Pre-requisitos

Antes de ejecutar este código, asegúrate de tener configurado:

1. **Perfil de AWS configurado**: Debe estar configurado en el nodo agente que ejecutará este código
2. **Permisos AWS**: El perfil/rol debe tener políticas que permitan:
   - Creación y gestión de redes (VPC, subnets, security groups)
   - Creación y gestión de instancias EC2
   - Acceso a servicios de networking (Internet Gateway, Route Tables)
3. **Herramientas instaladas**:
   - Terraform >= 1.12
   - Ansible >= 2.18
   - AWS CLI configurado
4. **SSH Key**: Debes tener una clave SSH configurada para acceder a las instancias EC2
5. **Configuración del Backend de Terraform**: Asegúrate de tener configurado un backend remoto para almacenar el estado de Terraform (S3, DynamoDB, etc.)

## 🏗️ Estructura del Proyecto

### `tf-modules/`
Contiene módulos reutilizables de Terraform para el proyecto:

- **`network/`**: Módulo para crear la infraestructura de red (VPC, subnets, Internet Gateway, Route Tables)
- **`vm/`**: Módulo para crear instancias EC2 con configuraciones específicas

> **Nota**: Estos módulos son versiones simplificadas para este escenario. En producción se recomienda mejorarlos con buenas prácticas de parametrización y validaciones adicionales.

### `tf-infra/`
Contiene la configuración principal de Terraform que utiliza los módulos:

- **`vpc/`**: Configuración para desplegar la red principal
- **`vm/`**: Configuración para desplegar las instancias EC2

### `tf-backend/`
Configuración para el backend de Terraform (almacenamiento del estado remoto).

### `tf-ansible-inventory/`
Scripts de Terraform para generar dinámicamente el inventario de Ansible:
- Obtiene las IPs elásticas del servidor web
- Obtiene las IPs privadas para comunicación interna
- Genera el archivo de inventario para Ansible

### `ansible-playbook/`
Contiene los playbooks de Ansible para configurar los servidores:
- Instalación de Apache en el servidor web
- Creación de usuarios del sistema
- Configuraciones específicas para cada tipo de servidor

## 🚀 Orden de Ejecución

### Paso 1: Desplegar la Infraestructura de Red

```bash
cd tf-infra/vpc
terraform init
terraform validate
terraform plan
terraform apply
```

### Paso 2: Desplegar las Instancias EC2

⚠️ **Importante**: Verificar que los filtros de datos en EC2 coincidan con los prefijos asignados en el ejercicio.

```bash
cd ../vm
terraform init
terraform validate
terraform plan
terraform apply
```

### Paso 3: Generar el Inventario de Ansible

```bash
cd ../../tf-ansible-inventory
terraform init
terraform apply
```

Este paso creará el archivo de inventario con:
- IP elástica del servidor web para acceso externo
- IPs privadas para comunicación interna entre servidores

### Paso 4: Ejecutar los Playbooks de Ansible

```bash
cd ../ansible-playbook
ansible-playbook -i inventory playbook.yml
```

## ⚠️ Consideraciones Importantes

### Conectividad de Red
- **No se utiliza NAT Gateway**: Las instancias EC2 en la red privada no tienen acceso directo a Internet
- Esto significa que las instancias privadas no pueden actualizar paquetes o instalar aplicaciones desde Internet
- Para operaciones que requieran acceso a Internet, considerar:
  - Implementar un NAT Gateway
  - Usar un bastion host para acceso indirecto
  - Pre-configurar AMIs con el software necesario

### Automatización CI/CD
Este flujo de ejecución está diseñado para ser integrado en pipelines de:
- **Jenkins**: Cada paso puede ser un stage del pipeline
- **GitHub Actions**: Cada paso puede ser un job con dependencias secuenciales

### Ejemplo simple Pipeline (Jenkins)**
```groovy
pipeline {
    agent any
    stages {
        stage('Deploy VPC') {
            steps {
                dir('tf-infra/vpc') {
                    sh 'terraform init && terraform apply -auto-approve'
                }
            }
        }
        stage('Deploy EC2') {
            steps {
                dir('tf-infra/vm') {
                    sh 'terraform init && terraform apply -auto-approve'
                }
            }
        }
        stage('Generate Inventory') {
            steps {
                dir('tf-ansible-inventory') {
                    sh 'terraform init && terraform apply -auto-approve'
                }
            }
        }
        stage('Configure Servers') {
            steps {
                dir('ansible-playbook') {
                    sh 'ansible-playbook -i inventory playbook.yml'
                }
            }
        }
    }
}
```

## 🧹 Limpieza de Recursos

Para destruir todos los recursos creados, ejecutar en orden inverso:

```bash
# 1. Limpiar inventario
cd tf-ansible-inventory
terraform destroy

# 2. Destruir instancias EC2
cd ../tf-infra/vm
terraform destroy

# 3. Destruir infraestructura de red
cd ../vpc
terraform destroy
```

## 📝 Notas Adicionales

- Los módulos están optimizados para este escenario específico y pueden ser mejorados para uso en producción
- Se recomienda revisar y ajustar los security groups según las necesidades de seguridad
- Considerar implementar outputs en los módulos para mejor trazabilidad
- Validar que las AMIs utilizadas estén disponibles en la región objetivo