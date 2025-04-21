# Flexget

## Descripción General
Flexget es una herramienta de automatización de descargas que se integra con Transmission para gestionar y organizar automáticamente el contenido multimedia descargado.

## Configuración

### Ubicación
- Directorio: `/flexget/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - `flexget/config.yml`: Configuración principal
  - `flexget/config.yml.org`: Configuración de respaldo

### Estructura
```plaintext
flexget/
├── docker-compose.yml
├── Dockerfile
└── flexget/
    ├── config.yml
    ├── db-config.sqlite
    ├── flexget.log
    └── custom-cont-init.d/
```

### Base de Datos
- `db-config.sqlite`: Base de datos principal
- `db-config-jobs.sqlite`: Base de datos de trabajos
- Backup automático diario

## Tareas Automatizadas

### Series TV
```yaml
series:
  settings:
    quality: 720p+
    propers: yes
  shows:
    - name: "Show Name"
      quality: 1080p
      season_packs: yes
```

### Películas
```yaml
movies:
  quality: 1080p
  min_year: 2000
  imdb:
    min_score: 6.5
  list: letterboxd
```

## Integración con Transmission

### Configuración
```yaml
transmission:
  host: transmission
  port: 9091
  username: admin
  password: password
  path: /downloads/complete
```

### Etiquetado
- Series: `/media/tv/`
- Películas: `/media/movies/`
- Música: `/media/music/`

## Filtros y Reglas

### Calidad
- Mínima: 720p
- Preferida: 1080p
- Máxima: 4K

### Fuentes
- Rastreadores privados
- RSS feeds
- Listas personalizadas

## Notificaciones

### Configuración
```yaml
notify:
  entries:
    via:
      - telegram:
          bot_token: token
          recipients:
            - chat_id
```

### Eventos
- Descarga iniciada
- Descarga completada
- Error en descarga
- Espacio bajo en disco

## Mantenimiento

### Tareas Diarias
1. Limpieza de base de datos
2. Actualización de listas
3. Verificación de feeds
4. Rotación de logs

### Backups
```yaml
backup:
  - config.yml
  - db-config.sqlite
  - custom-cont-init.d/
```

## Monitoreo

### Logs
```bash
# Ver logs en tiempo real
docker logs -f flexget
```

### Web UI
- Puerto: 5050
- Autenticación requerida
- Estadísticas en tiempo real
- Estado de tareas

## Resolución de Problemas

### Problemas Comunes
1. Base de datos bloqueada:
   ```bash
   # Reparar base de datos
   docker exec flexget flexget database reset --sure
   ```

2. Feeds fallidos:
   ```bash
   # Verificar feeds
   docker exec flexget flexget check
   ```

### Diagnóstico
- Verificar conectividad
- Revisar permisos
- Comprobar espacio
- Validar configuración

## Recuperación

### Respaldo
1. Configuración
   - config.yml
   - variables de entorno
   - bases de datos

2. Datos
   - historial de descargas
   - estado de tareas
   - listas personalizadas

### Restauración
1. Detener servicio
2. Restaurar archivos
3. Verificar permisos
4. Reiniciar Flexget

## Mejores Prácticas

### Configuración
- Usar plantillas
- Documentar reglas
- Mantener respaldos
- Actualizar regularmente

### Rendimiento
- Limitar concurrencia
- Optimizar intervalos
- Gestionar caché
- Monitorear recursos

### Organización
- Estructura clara
- Nombrado consistente
- Separar configuraciones
- Mantener logs limpios