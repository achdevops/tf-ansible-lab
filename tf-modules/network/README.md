# Módulo de Red VPC AWS

## Descripción

Este módulo de Terraform crea una infraestructura de red completa en AWS que incluye VPC, subnets públicas y privadas, gateways y tablas de enrutamiento. Está diseñado para ser reutilizable y escalable para múltiples ambientes.


## Recursos Creados

### VPC y Conectividad
- **aws_vpc**: Red virtual privada con DNS habilitado
- **aws_internet_gateway**: Gateway para acceso a internet
- **aws_eip**: Elastic IPs para NAT Gateways
- **aws_nat_gateway**: NAT Gateways para acceso saliente desde subnets privadas

### Subnets
- **aws_subnet (public)**: 2 subnets públicas en diferentes AZs
- **aws_subnet (private)**: 2 subnets privadas en diferentes AZs

### Enrutamiento
- **aws_route_table (public)**: Tabla de enrutamiento para subnets públicas
- **aws_route_table (private)**: Tablas de enrutamiento para subnets privadas
- **aws_route_table_association**: Asociaciones entre subnets y tablas de enrutamiento

### Fuentes de Datos
- **data.aws_availability_zones**: Obtiene las zonas de disponibilidad disponibles

## Variables de Entrada

| Variable | Descripción | Tipo | Valor por Defecto |
|----------|-------------|------|-------------------|
| `name_prefix` | Prefijo para nombres de recursos | string | "main" |
| `vpc_cidr` | CIDR block para la VPC | string | "10.0.0.0/16" |
| `public_subnet_cidrs` | CIDR blocks para subnets públicas | list(string) | ["10.0.1.0/24", "10.0.2.0/24"] |
| `private_subnet_cidrs` | CIDR blocks para subnets privadas | list(string) | ["10.0.3.0/24", "10.0.4.0/24"] |
| `enable_nat_gateway` | Habilitar NAT Gateway | bool | true |
| `tags` | Tags para aplicar a todos los recursos | map(string) | {} |

## Outputs

| Output | Descripción |
|--------|-------------|
| `vpc_id` | ID de la VPC |
| `vpc_cidr_block` | CIDR block de la VPC |
| `public_subnet_ids` | IDs de las subnets públicas |
| `private_subnet_ids` | IDs de las subnets privadas |
| `internet_gateway_id` | ID del Internet Gateway |
| `nat_gateway_ids` | IDs de los NAT Gateways |
| `public_route_table_id` | ID de la tabla de enrutamiento pública |
| `private_route_table_ids` | IDs de las tablas de enrutamiento privadas |

## Uso

### Ejemplo Básico

```hcl
module "vpc" {
  source = "../../tf-modules/network"

  name_prefix = "mi-proyecto"
  vpc_cidr    = "18.0.0.0/16"
  
  tags = {
    Environment = "dev"
    Project     = "mi-proyecto"
  }
}
```

### Ejemplo Avanzado

```hcl
module "vpc" {
  source = "../../tf-modules/network"

  name_prefix            = "cloudlabs-dev"
  vpc_cidr              = "17.0.0.0/16"
  public_subnet_cidrs   = ["17.0.1.0/24", "17.0.2.0/24"]
  private_subnet_cidrs  = ["17.0.3.0/24", "17.0.4.0/24"]
  enable_nat_gateway    = true

  tags = {
    Environment = "dev"
    Project     = "cloudlabs"
    Owner       = "devsecops"
    ManagedBy   = "terraform"
  }
}
```

### Deshabilitando NAT Gateway (para ahorrar costos)

```hcl
module "vpc" {
  source = "./modules/network"

  name_prefix        = "test-vpc"
  enable_nat_gateway = false
  
  tags = {
    Environment = "test"
    CostCenter  = "development"
  }
}
```

## Características

### Alta Disponibilidad
- Subnets distribuidas en múltiples zonas de disponibilidad
- NAT Gateways redundantes en cada AZ

### Seguridad
- Subnets privadas sin acceso directo a internet
- Acceso saliente controlado a través de NAT Gateways

### Escalabilidad
- Fácil agregar más subnets modificando las listas de CIDR
- Configuración flexible por ambiente

### Costos
- Opción para deshabilitar NAT Gateways en ambientes de prueba
- Uso eficiente de recursos

## Requisitos

### Terraform
- Terraform >= 1.12
- Provider AWS >= 6.2

### Permisos AWS
- ec2:CreateVpc
- ec2:CreateSubnet
- ec2:CreateInternetGateway
- ec2:CreateNatGateway
- ec2:CreateRouteTable
- ec2:CreateRoute
- ec2:AllocateAddress
- ec2:AssociateRouteTable
- ec2:DescribeAvailabilityZones
- ec2:CreateTags

## Consideraciones

1. **Costos**: Los NAT Gateways tienen costo por hora y por GB transferido
2. **Límites**: AWS tiene límites en el número de VPCs y subnets por región
3. **CIDR**: Planificar bien los rangos CIDR para evitar conflictos
4. **AZs**: Verificar que la región tenga suficientes zonas de disponibilidad

## Ejemplo de Referencia

```hcl
# Usar outputs del módulo en otros recursos
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1d0"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  
  tags = {
    Name = "web-server"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = module.vpc.private_subnet_ids

  tags = {
    Name = "Main DB subnet group"
  }
}
```
