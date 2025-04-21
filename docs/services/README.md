# Servicios de Kronos Server

## Resumen de Servicios

### Infraestructura Base

#### [Traefik](./traefik.md)
- Proxy inverso y balanceador de carga
- Gestión de certificados SSL/TLS
- Enrutamiento dinámico
- Dashboard de administración

#### [Cloudflare](./cloudflare.md)
- Gestión DNS dinámica
- Protección DDoS
- CDN global
- Certificados SSL

#### [Pi-hole](./pihole.md)
- Servidor DNS local
- Bloqueo de anuncios
- Filtrado de contenido
- Estadísticas de red

### Servicios Multimedia

#### [Immich](./immich.md)
- Gestión de fotos
- Machine Learning
- Reconocimiento facial
- Transcoding de medios

#### [Plex](./plex.md)
- Servidor de streaming
- Biblioteca multimedia
- Transcoding adaptativo
- Acceso remoto

### Gestión y Monitoreo

#### [Portainer](./portainer.md)
- Gestión de contenedores Docker
- Monitoreo de recursos
- Gestión de volúmenes
- Administración de redes

### Comunicaciones

#### [Poste.io](./postie.md)
- Servidor de correo
- Antispam/Antivirus
- Webmail
- Autenticación DKIM/SPF

### Descargas y Automatización

#### [Transmission](./transmission.md)
- Cliente BitTorrent
- Interfaz web
- Control de ancho de banda
- Gestión de descargas

#### [Flexget](./flexget.md)
- Automatización de descargas
- Integración con Transmission
- Filtrado de contenido
- Programación de tareas

## Puertos y Acceso

### Servicios Web
| Servicio     | Puerto | URL                            |
|--------------|--------|--------------------------------|
| Traefik      | 443    | dashboard.example.com    |
| Portainer    | 9000   | portainer.example.com    |
| Plex         | 32400  | plex.example.com        |
| Immich       | 3001   | immich.example.com      |
| Transmission | 9091   | transmission.example.com |
| Flexget      | 5050   | flexget.example.com     |

### Servicios de Sistema
| Servicio  | Puerto | Protocolo       |
|-----------|--------|-----------------|
| Pi-hole   | 53     | DNS (TCP/UDP)   |
| Poste.io  | 25     | SMTP            |
|           | 465    | SMTPS           |
|           | 587    | SMTP (TLS)      |
|           | 993    | IMAPS           |

## Dependencias entre Servicios

### Cadena de Inicio
1. Redes Docker
2. Pi-hole (DNS)
3. Traefik (Proxy)
4. Servicios base (Redis, PostgreSQL)
5. Servicios principales
6. Servicios auxiliares

### Integración
```plaintext
Traefik ─── [Todos los servicios web]
   │
   ├── Immich ─── PostgreSQL
   │              └── Redis
   │
   ├── Transmission ─── Flexget
   │
   └── Poste.io ─── Pi-hole (DNS)
```

## Estado de los Servicios

### Monitoreo
- Portainer: Estado general de contenedores
- Traefik: Métricas de tráfico web
- Pi-hole: Estadísticas DNS
- Logs centralizados

### Alertas
- Caída de servicios
- Uso de recursos
- Errores de aplicación
- Problemas de red

## Mantenimiento

### Respaldos
- Configuraciones en `/home/xxxx/kronos-server/*/config/`
- Datos en `/mnt/storage/`
- Bases de datos
- Certificados SSL

### Actualizaciones
- Imágenes Docker
- Configuraciones
- Dependencias
- Sistemas base

## Documentación Específica

Cada servicio tiene su propia documentación detallada que incluye:
- Configuración específica
- Procedimientos de mantenimiento
- Resolución de problemas
- Mejores prácticas