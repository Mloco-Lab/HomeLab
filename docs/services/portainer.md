# Portainer

## Descripción General
Portainer es una interfaz gráfica de gestión de contenedores Docker que proporciona una forma fácil de administrar contenedores, imágenes, redes y volúmenes en el Servidor.

## Configuración

### Ubicación
- Directorio: `/portainer/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - Volumen persistente para datos

### Acceso
- URL: `portainer.example.com`
- Puerto: 9000 (interno)
- SSL vía Traefik
- Autenticación requerida

## Características Principales

### Gestión de Contenedores
- Creación/eliminación
- Inicio/parada
- Monitoreo en tiempo real
- Logs y estadísticas

### Redes Docker
```yaml
networks:
  servidor-net:
    driver: bridge
    internal: false
    enable_ipv6: true
```

### Volúmenes
- Listado de volúmenes
- Backup/restore
- Limpieza
- Monitoreo de espacio

## Seguridad

### Configuración
```yaml
security:
  # Configuración SSL
  ssl: true
  ssl_cert: /certs/portainer.crt
  ssl_key: /certs/portainer.key
  
  # Autenticación
  admin_password: <hash>
  authentication_method: internal
```

### Control de Acceso
- Usuarios y equipos
- Roles personalizados
- LDAP (opcional)
- OAuth2 (opcional)

## Monitoreo

### Métricas de Sistema
- CPU por contenedor
- Memoria utilizada
- I/O de disco
- Tráfico de red

### Alertas
```yaml
alerts:
  - type: container_down
    notify: true
    channels: ['email', 'webhook']
  - type: high_cpu
    threshold: 80
    duration: 5m
```

## Mantenimiento

### Tareas Automáticas
1. Limpieza de imágenes
2. Actualización de contenedores
3. Respaldo de configuración
4. Rotación de logs

### Backups
```bash
# Directorios a respaldar
/data/portainer/
├── certs/
├── compose/
└── config.json
```

## Gestión de Stacks

### Ejemplo de Stack
```yaml
version: '3.8'
services:
  webapp:
    image: nginx
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
```

### Templates
- Templates personalizados
- App Templates
- Stack Templates
- Container Templates

## Resolución de Problemas

### Problemas Comunes
1. Problemas de acceso:
   ```bash
   # Verificar estado
   docker logs portainer
   # Reiniciar servicio
   docker restart portainer
   ```

2. Problemas de recursos:
   ```bash
   # Limpiar recursos
   docker system prune -a
   ```

### Diagnóstico
- Estado de contenedores
- Logs del sistema
- Uso de recursos
- Conectividad de red

## Recuperación

### Plan de Recuperación
1. Backup de datos
   ```bash
   # Respaldar volumen
   docker run --rm -v portainer_data:/data \
     -v /backup:/backup alpine \
     tar czf /backup/portainer.tar.gz /data
   ```

2. Restauración
   ```bash
   # Restaurar volumen
   docker run --rm -v portainer_data:/data \
     -v /backup:/backup alpine \
     tar xzf /backup/portainer.tar.gz -C /
   ```

## Mejores Prácticas

### Seguridad
- Cambiar contraseña por defecto
- Usar SSL/TLS
- Limitar acceso por IP
- Actualizar regularmente

### Rendimiento
- Limitar número de contenedores
- Monitorear uso de recursos
- Limpiar recursos no utilizados
- Optimizar networking

### Organización
- Usar etiquetas descriptivas
- Mantener documentación
- Seguir convenciones de nombres
- Gestionar stacks eficientemente