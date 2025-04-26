# Transmission

## Descripción General
Transmission es un cliente BitTorrent ligero y eficiente que se utiliza como el motor principal de descargas en el Servidor. Se integra con Flexget para la automatización de descargas.

## Configuración

### Ubicación
- Directorio: `/transmission/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - `transmission/settings.json`: Configuración del cliente

### Estructura
```plaintext
transmission/
├── docker-compose.yml
└── transmission/
    ├── settings.json
    ├── stats.json
    ├── blocklists/
    ├── resume/
    └── torrents/
```

### Variables de Entorno
```plaintext
PUID=1000
PGID=1000
TZ=Europe/Madrid
TRANSMISSION_WEB_HOME=/combustion-release/
TRANSMISSION_RPC_USERNAME=admin
TRANSMISSION_RPC_PASSWORD=<password>
```

### Puertos
- 9091: Interfaz web
- 51413: Puerto BitTorrent (TCP/UDP)

## Directorios de Trabajo

### Estructura de Almacenamiento
```plaintext
/mnt/storage/
├── downloads/
│   ├── complete/
│   ├── incomplete/
│   └── watch/
└── media/
    ├── movies/
    ├── tv/
    └── music/
```

### Permisos
- Usuario: 1000 (transmission)
- Grupo: 1000 (transmission)
- Directorios: 775
- Archivos: 664

## Integración con Flexget

### Configuración RPC
```yaml
rpc-enabled: true
rpc-bind-address: "0.0.0.0"
rpc-whitelist-enabled: false
rpc-host-whitelist-enabled: false
```

### API Settings
- URL: `http://transmission:9091/transmission/rpc`
- Autenticación: Básica
- Límites de velocidad configurables

## Seguridad

### Acceso
- Autenticación requerida
- Lista blanca de IPs
- SSL/TLS vía Traefik

### Blocklists
- Actualización automática
- Múltiples fuentes
- Rotación programada

## Rendimiento

### Ajustes Recomendados
```json
{
    "cache-size-mb": 512,
    "queue-stalled-minutes": 30,
    "ratio-limit": 2.0,
    "ratio-limit-enabled": true
}
```

### Límites
- Descargas simultáneas: 5
- Subidas simultáneas: 10
- Caché: 512MB
- Ratio global: 2.0

## Monitoreo

### Logs
```bash
# Ver logs en tiempo real
docker logs -f transmission
```

### Métricas
- Velocidad de descarga/subida
- Ratio por torrent
- Espacio en disco
- Estado de la cola

## Mantenimiento

### Tareas Programadas
1. Limpieza de torrents completados
2. Actualización de blocklists
3. Optimización de base de datos
4. Verificación de espacio

### Scripts de Mantenimiento
```bash
# Limpiar torrents antiguos
transmission-remote -n 'user:pass' --torrent-done-seeding

# Actualizar blocklists
transmission-remote -n 'user:pass' --blocklist-update
```

## Resolución de Problemas

### Problemas Comunes
1. Puerto bloqueado:
   ```bash
   # Verificar puerto
   netstat -tuln | grep 51413
   ```

2. Problemas de permisos:
   ```bash
   # Corregir permisos
   chown -R transmission:transmission /mnt/storage/downloads
   ```

### Verificaciones
- Conectividad de red
- Espacio disponible
- Estado del servicio
- Logs de errores

## Recuperación

### Respaldo
- settings.json
- stats.json
- Base de datos de torrents
- Blocklists personalizadas

### Restauración
1. Detener servicio
2. Restaurar configuración
3. Verificar permisos
4. Reiniciar servicio

## Mejores Prácticas

### Rendimiento
- Usar disco rápido para incompletos
- Configurar caché adecuadamente
- Limitar conexiones máximas
- Habilitar DHT y PEX

### Organización
- Estructura de carpetas clara
- Nombrado consistente
- Separar completos/incompletos
- Mantener ratio saludable