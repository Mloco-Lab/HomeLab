# Kronos Server

Este es un servidor Docker auto-gestionado que proporciona varios servicios fundamentales para una infraestructura doméstica.

## Estructura del Servidor

El servidor está organizado en varios servicios independientes, cada uno en su propio directorio y gestionado por Docker Compose. La comunicación entre servicios se realiza a través de la red `kronos-net`.

### Servicios Principales

#### Traefik (traefik/)
- Proxy inverso y balanceador de carga
- Gestiona automáticamente certificados SSL/TLS con Cloudflare
- Proporciona acceso seguro a todos los servicios web
- Dashboard disponible en: `dashboard.kronos.cloudns.ph`
- Configuración almacenada en `data/traefik.yml`
- Certificados SSL almacenados en `data/acme.json`

#### Cloudflare (cloudflare/)
- Integración con Cloudflare para DNS dinámico
- Gestión de registros DNS
- Token de API almacenado de forma segura

#### Pi-hole (pihole/)
- Servidor DNS local con bloqueo de anuncios
- Protección de red completa
- Bloqueo de dominios maliciosos y publicidad
- Configuración personalizada en `etc-pihole/`
- Sistema de respaldo automático en `bkp/`
- Integrado con systemd-resolved para evitar conflictos de puerto
- Gestión de DNS local para servicios internos

#### Immich (immich-app/)
- Servidor de fotos auto-hospedado
- Soporte para aceleración por hardware en transcoding y ML
- Incluye servicios de Machine Learning
- Base de datos PostgreSQL integrada
- Redis para caché
- Almacenamiento configurado en volumen dedicado
- Accesible en: `immich.kronos.cloudns.ph`

### Herramientas de Mantenimiento

#### Scripts (scripts/)
Conjunto de herramientas para mantenimiento y monitoreo del sistema:
- `maintenance.sh`: Mantenimiento diario automatizado
- `monitor.sh`: Monitoreo en tiempo real
- `generate_report.sh`: Generación de informes del sistema
- `update.sh`: Actualización segura del sistema
- `check_status.sh`: Verificación rápida del estado

Para más detalles sobre los scripts, consulta la [documentación de scripts](./docs/scripts.md).

### Documentación

La documentación completa del sistema está disponible en el directorio `docs/`:
- [Visión General](./docs/overview.md)
- [Servicios](./docs/services/README.md)
- [Redes](./docs/networking.md)
- [Mantenimiento](./docs/maintenance.md)
- [Scripts](./docs/scripts.md)
- [Respaldos](./docs/backups.md)
- [Resolución de Problemas](./docs/troubleshooting.md)

## Gestión de Servicios

### Scripts de Control
- `start-all.sh`: Inicia todos los servicios en el orden correcto
- `stop-all.sh`: Detiene todos los servicios de manera segura
- Manejo de dependencias entre servicios

### Red
La red `kronos-net` conecta todos los servicios y está gestionada en el directorio `networks/`. Proporciona:
- Aislamiento de servicios
- Comunicación interna segura
- Resolución DNS interna

### Configuración
- Cada servicio tiene su propio archivo `.env` para variables de entorno
- Los volúmenes Docker garantizan la persistencia de datos
- Configuraciones sensibles almacenadas de forma segura

## Requisitos
- Docker y Docker Compose
- Suficiente espacio en disco para almacenamiento multimedia
- Puertos necesarios abiertos en el router/firewall
- Resolución DNS configurada para usar Pi-hole

## Mantenimiento
- Los contenedores están configurados para reiniciarse automáticamente
- Los certificados SSL se renuevan automáticamente a través de Traefik
- Sistema de respaldo configurado para configuraciones críticas
- Logs rotados automáticamente
- Monitoreo de recursos a través de Portainer
- Scripts automatizados para mantenimiento y monitoreo