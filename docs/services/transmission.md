# Transmission

## Descripción General

Cliente BitTorrent con interfaz web, gestión de descargas y monitoreo de recursos.

## Configuración Base

### Ubicación

- Directorio: `/transmission/`
- Datos: `/transmission/`
- Configuración: `/transmission/settings.json`

### Estructura

```plaintext
transmission/
├── config/
│   ├── settings.json
│   └── stats.json
├── downloads/
│   ├── complete/
│   └── incomplete/
└── watch/
```

### Variables de Entorno

```plaintext
PUID=1000
PGID=1000
TZ=Europe/Madrid
TRANSMISSION_WEB_HOME=/transmission-web-home/
```

### Puertos

- 9091: Interfaz web
- 51413: BitTorrent (TCP)
- 51413: BitTorrent (UDP)

## Almacenamiento

### Estructura de Almacenamiento

```plaintext
/transmission/
├── downloads/
│   ├── complete/       # Descargas finalizadas
│   └── incomplete/     # Descargas en proceso
├── watch/             # Monitoreo de .torrent
└── config/            # Configuración
```

### Permisos

- Usuario: 1000 (transmission)
- Grupo: 1000 (transmission)
- Modo: 755 directorios
- Modo: 644 archivos

## Configuración Avanzada

### Configuración RPC

```yaml
rpc-settings:
  rpc-authentication-required: true
  rpc-username: "admin"
  rpc-password: "encrypted-password"
  rpc-whitelist-enabled: true
  rpc-whitelist: "127.0.0.1,192.168.1.*"
```

### API Settings

- URL: `http://transmission:9091/transmission/rpc`
- Autenticación: Basic Auth
- Timeout: 30s
- Retry: 3

### Acceso

- Autenticación requerida
- HTTPS vía Traefik
- Whitelist de IPs
- Rate limiting

### Blocklists

- Actualización automática
- Fuentes verificadas
- Formato P2P
- Rotación semanal

## Optimización

### Ajustes Recomendados

```json
{
  "speed-limit-down": 10000,
  "speed-limit-up": 5000,
  "alt-speed-enabled": true,
  "alt-speed-time-enabled": true,
  "alt-speed-time-begin": 480,
  "alt-speed-time-end": 1380,
  "download-queue-size": 5,
  "queue-stalled-enabled": true,
  "incomplete-dir-enabled": true
}
```

### Límites

- Descargas simultáneas: 5
- Máx. conexiones: 200
- Máx. peers: 50
- Cache: 512MB

## Monitoreo

### Logs

```bash
# Ver logs en tiempo real
docker logs -f transmission

# Filtrar errores
docker logs transmission | grep ERROR
```

### Métricas

- Velocidad de descarga/subida
- Ratio global/individual
- Espacio utilizado
- Peers conectados

## Mantenimiento

### Tareas Programadas

1. Limpieza de torrents completados
2. Actualización de blocklists
3. Verificación de datos
4. Backup de configuración

### Scripts de Mantenimiento

```bash
#!/bin/bash
# Limpieza de torrents antiguos
find /transmission/downloads/complete -mtime +30 -exec rm -rf {} \;

# Verificación de espacio
df -h /transmission/downloads
```

## Solución de Problemas

### Problemas Comunes

1. Puerto bloqueado:

   ```bash
   # Verificar puerto
   netstat -tulpn | grep 51413
   
   # Probar conectividad
   nc -vz localhost 51413
   ```

### Verificaciones

- Conectividad de red
- Espacio disponible
- Permisos correctos
- Estado del servicio

### Respaldo

- settings.json
- blocklists
- estadísticas
- torrents activos

### Restauración

1. Detener servicio
2. Restaurar configs
3. Verificar permisos
4. Reiniciar Transmission

## Mejores Prácticas

### Optimización de Recursos

- Usar disco rápido para incompletos
- Limitar ancho de banda
- Configurar caché
- Priorizar descargas

### Organización

- Estructura de carpetas clara
- Nombrado consistente
- Categorización
- Mantener ratio saludable
