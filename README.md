# Servidor

## Estructura del Servidor

### Servicios Principales

#### Traefik (traefik/)

- Proxy inverso y balanceador de carga
- Gestiona automáticamente certificados SSL/TLS con Cloudflare
- Proporciona acceso seguro a todos los servicios web
- Dashboard disponible en: `dashboard.example.com`

#### Cloudflare (cloudflare/)

- Integración con Cloudflare para DNS dinámico
- Gestión de registros DNS
- Protección DDoS
- SSL/TLS

#### Pi-hole (pihole/)

- Servidor DNS local con bloqueo de anuncios
- Filtrado de contenido
- Estadísticas detalladas
- Interfaz de administración web

#### Immich (immich-app/)

- Servidor de fotos auto-hospedado
- Backup automático de fotos
- Reconocimiento facial
- Búsqueda avanzada

#### Scripts (scripts/)

- `maintenance.sh`: Mantenimiento diario automatizado
- `monitor.sh`: Monitoreo de servicios
- `backup.sh`: Copias de seguridad
- `update.sh`: Actualizaciones automáticas

## Documentación

- [Visión General](./docs/overview.md)
- [Mantenimiento](./docs/maintenance.md)
- [Redes](./docs/networking.md)
- [Scripts](./docs/scripts.md)

### Scripts de Control

- `start-all.sh`: Inicia todos los servicios en el orden correcto
- `stop-all.sh`: Detiene todos los servicios de forma segura
- `restart.sh`: Reinicia servicios específicos

### Red

- Aislamiento de servicios
- VLAN para servicios críticos
- Tráfico cifrado
- Firewall configurado

### Configuración

- Cada servicio tiene su propio archivo `.env` para variables de entorno
- Archivos de configuración versionados
- Secretos gestionados de forma segura
- Templates para nueva configuración

## Requisitos

- Docker y Docker Compose
- Sistema Linux
- 4GB RAM mínimo
- Puerto 80/443 accesible

## Mantenimiento

- Los contenedores están configurados para reiniciarse automáticamente
- Backups diarios de datos críticos
- Monitoreo continuo de recursos
- Scripts automatizados para mantenimiento y monitoreo
