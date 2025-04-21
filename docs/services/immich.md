# Immich

## Descripción General
Immich es una solución de gestión y almacenamiento de fotos auto-hospedada que incluye capacidades de Machine Learning para reconocimiento de objetos y rostros. El servicio está diseñado para ser una alternativa a Google Photos.

## Componentes

### Servicios Docker
1. **immich-server**: API principal y servidor web
2. **immich-machine-learning**: Servicio de ML para análisis de imágenes
3. **redis**: Caché para mejorar el rendimiento
4. **database**: PostgreSQL para almacenamiento de metadatos

## Configuración

### Ubicación
- Directorio: `/immich-app/`
- Archivos principales:
  - `docker-compose.yml`: Configuración principal
  - `hwaccel.ml.yml`: Configuración de aceleración por hardware para ML
  - `hwaccel.transcoding.yml`: Configuración de transcoding

### Variables de Entorno
```plaintext
DB_HOSTNAME=immich_postgres
DB_USERNAME=postgres
DB_PASSWORD=<password>
DB_DATABASE_NAME=immich

REDIS_HOSTNAME=immich_redis

UPLOAD_LOCATION=/mnt/storage/photos
```

### Almacenamiento
- Directorio principal: `/mnt/storage/photos`
- Estructura de directorios:
  ```plaintext
  /mnt/storage/photos/
  ├── uploads/
  ├── thumbs/
  └── encoded/
  ```

## Machine Learning

### Capacidades
- Reconocimiento facial
- Detección de objetos
- Clasificación de escenas
- Extracción de texto (OCR)

### Configuración de Hardware
```yaml
# Ejemplo de configuración de GPU
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

## Base de Datos

### PostgreSQL
- Nombre: immich
- Puerto: 5432
- Respaldos automáticos
- Índices optimizados

### Redis
- Caché de sesiones
- Cola de trabajos
- Persistencia habilitada

## Mantenimiento

### Actualizaciones
1. Respaldar base de datos
2. Actualizar imágenes Docker
3. Migrar esquema si es necesario
4. Verificar ML y transcoding

### Backups
- Base de datos: dumps diarios
- Imágenes: respaldo incremental
- Configuración: versionada
- Logs: rotación semanal

## Monitoreo

### Logs
```bash
# Ver logs de servicios específicos
docker logs immich-server
docker logs immich-machine-learning
```

### Métricas
- Uso de CPU/GPU
- Espacio en disco
- Rendimiento de la base de datos
- Tiempos de procesamiento ML

## Resolución de Problemas

### Problemas Comunes
1. Problemas de ML:
   ```bash
   # Verificar GPU
   nvidia-smi
   # Reiniciar servicio ML
   docker restart immich-machine-learning
   ```

2. Problemas de almacenamiento:
   ```bash
   # Verificar espacio
   df -h /mnt/storage
   # Limpiar caché
   docker exec immich-server npm run clean-cache
   ```

### Verificaciones
- Conexión a la base de datos
- Estado de Redis
- Acceso al almacenamiento
- Funcionamiento de ML

## Mejores Prácticas

### Rendimiento
- Usar SSD para la base de datos
- Habilitar aceleración por hardware
- Optimizar tamaño de caché
- Indexar directorios grandes

### Seguridad
- Usar autenticación fuerte
- Encriptar respaldos
- Limitar acceso a directorios
- Actualizar regularmente

### Almacenamiento
- Monitorear espacio libre
- Implementar política de retención
- Verificar integridad de archivos
- Mantener respaldos externos

## Recuperación

### Plan de Recuperación
1. Restaurar base de datos
2. Verificar archivos de media
3. Reconfigurar servicios
4. Validar funcionalidad ML

### Verificación Post-Recuperación
- Acceso a la interfaz web
- Funcionalidad de búsqueda
- Procesamiento ML
- Generación de miniaturas