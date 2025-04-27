# Servicios

## Servicios del Sistema

### Traefik

- Proxy inverso y balanceador de carga
- Gestión de SSL/TLS
- Enrutamiento de servicios

### Cloudflare

- Gestión DNS dinámica
- Protección DDoS
- CDN global

### Pi-hole

- Servidor DNS local
- Bloqueo de anuncios
- Filtrado de contenido

### Immich

- Gestión de fotos
- Reconocimiento facial
- Búsqueda por ML

### Plex

- Servidor de streaming
- Transcoding automático
- Metadatos enriquecidos

### Portainer

- Gestión de contenedores Docker
- Monitoreo de recursos
- Administración remota

### Poste.io

- Servidor de correo
- Anti-spam integrado
- Webmail incluido

### Transmission

- Cliente BitTorrent
- Gestión remota
- Programación de descargas

### Flexget

- Automatización de descargas
- Filtrado de contenido
- Integración con trackers

## Puertos y URLs

### Servicios Web

| Servicio     | Puerto | URL                            |
|--------------|--------|--------------------------------|
| Traefik      | 8080   | traefik.example.com           |
| Portainer    | 9000   | portainer.example.com         |
| Plex         | 32400  | plex.example.com              |
| Immich       | 3001   | photos.example.com            |
| Transmission | 9091   | transmission.example.com       |
| Pi-hole      | 80     | pihole.example.com            |
| Flexget      | 5050   | flexget.example.com           |

### Servicios de Sistema

| Servicio  | Puerto | Protocolo       |
|-----------|--------|-----------------|
| Traefik   | 80/443 | HTTP/HTTPS     |
| Pi-hole   | 53     | DNS (TCP/UDP)  |
| Postie    | 25     | SMTP           |
| Postie    | 465    | SMTPS         |
| Postie    | 993    | IMAPS         |

## Gestión

### Cadena de Inicio

1. Redes Docker
2. Traefik (proxy)
3. Pi-hole (DNS)
4. Servicios principales
5. Servicios secundarios

### Integración

```plaintext
Traefik -> Servicios Web
Pi-hole -> DNS Local
Postie -> Email
```

### Monitoreo

- Portainer: Estado general de contenedores
- Traefik: Métricas de proxy
- Pi-hole: Estadísticas DNS

### Alertas

- Caída de servicios
- Uso de recursos
- Errores de autenticación

### Respaldos

- Configuraciones en `/home/xxxx/servidor/*/config/`
- Bases de datos
- Logs importantes

### Actualizaciones

- Imágenes Docker
- Configuración específica
- Mejores prácticas
