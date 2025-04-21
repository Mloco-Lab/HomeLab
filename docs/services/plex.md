# Plex Media Server

## Descripción General
Plex Media Server es una solución de streaming multimedia que organiza y transmite contenido de video, música y fotos. Se integra con los servicios de descarga automatizada para proporcionar una experiencia completa de centro multimedia.

## Configuración

### Ubicación
- Directorio: `/plex/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - Volúmenes para biblioteca multimedia

### Estructura de Directorios
```plaintext
/mnt/storage/
├── media/
│   ├── movies/
│   ├── tv/
│   ├── music/
│   └── photos/
└── transcode/
    └── temp/
```

### Hardware
- Transcoding por hardware (NVIDIA/QuickSync)
- Cache en SSD
- Red Gigabit
- Memoria dedicada

## Bibliotecas

### Configuración
1. Movies
   ```yaml
   type: movie
   path: /media/movies
   scan_interval: 1h
   ```

2. TV Shows
   ```yaml
   type: show
   path: /media/tv
   season_folders: true
   ```

3. Music
   ```yaml
   type: music
   path: /media/music
   metadata_agents: 
     - Musicbrainz
   ```

### Agentes de Metadatos
- TheMovieDB
- TheTVDB
- Musicbrainz
- IMDB

## Transcoding

### Configuración
```yaml
transcoder:
  hardware_acceleration: true
  quality_default: 8
  max_simultaneous_transcodes: 4
```

### Perfiles
- Original
- 1080p (10Mbps)
- 720p (4Mbps)
- SD (2Mbps)

## Acceso Remoto

### Configuración
- Puerto: 32400
- SSL habilitado
- Autenticación requerida
- Límites por usuario

### Red
- UPNP/NAT-PMP
- IPv6 (si disponible)
- Relay deshabilitado
- Bandwidth limits

## Integración

### Transmission/Flexget
- Monitoreo de directorios
- Escaneo automático
- Nomenclatura consistente
- Organización automática

### Notificaciones
```yaml
notifications:
  - type: email
    enabled: true
    on_added: true
    on_play: false
  - type: webhook
    url: http://internal/notify
```

## Mantenimiento

### Tareas Automáticas
1. Análisis de biblioteca
2. Limpieza de caché
3. Actualización de metadatos
4. Optimización de base de datos

### Respaldos
```bash
# Directorios a respaldar
/config/Library/
/config/Preferences.xml
/config/Logs/
```

## Monitoreo

### Métricas
- Sesiones activas
- Uso de CPU/GPU
- Ancho de banda
- Espacio en disco

### Logs
- Plex Media Server.log
- Plugin logs
- Transcoder logs
- Scanner logs

## Resolución de Problemas

### Problemas Comunes
1. Problemas de transcoding:
   ```bash
   # Verificar GPU
   nvidia-smi
   # Limpiar caché de transcoding
   rm -rf /transcode/temp/*
   ```

2. Problemas de escaneo:
   ```bash
   # Forzar re-escaneo
   docker exec plex curl http://localhost:32400/library/sections/all/refresh
   ```

### Verificaciones
- Permisos de archivos
- Conectividad de red
- Rendimiento de disco
- Estado del servidor

## Recuperación

### Respaldo
1. Configuración
   - Preferencias
   - Base de datos
   - Metadatos

2. Contenido
   - Archivos multimedia
   - Carátulas/posters
   - Subtítulos

### Restauración
1. Detener Plex
2. Restaurar configs
3. Verificar permisos
4. Reiniciar servicio

## Mejores Prácticas

### Organización
- Estructura consistente
- Nombrado estándar
- Metadatos completos
- Colecciones organizadas

### Rendimiento
- Cache en SSD
- Transcoding optimizado
- Red dedicada
- Monitoreo activo

### Seguridad
- Actualizaciones automáticas
- Acceso limitado
- SSL habilitado
- Respaldos regulares