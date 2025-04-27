# Portainer

## Descripción General

Interfaz de gestión para Docker, permitiendo administrar contenedores, imágenes, redes y volúmenes a través de una interfaz web.

## Configuración Base

### Ubicación

- Directorio: `/portainer/`
- Datos: `/data/`
- Configuración: `/config/`

### Acceso

- URL: `portainer.example.com`
- Puerto: 9000
- SSL/TLS vía Traefik

## Gestión

### Gestión de Contenedores

- Creación/eliminación
- Start/stop/restart
- Monitoreo de estado
- Logs en tiempo real

### Redes Docker

```yaml
networks:
  servidor-net:
    external: true
  interno:
    internal: true
```

### Volúmenes

- Listado de volúmenes
- Backup/restore
- Limpieza automática
- Monitoreo de espacio

### Ajustes del Sistema

```yaml
settings:
  ssl: true
  template_version: 2
  edge_enabled: false
  snapshot_interval: 5m
  allow_bindmounts: false
  allow_privileged: false
```

### Control de Acceso

- Usuarios y equipos
- Roles y permisos
- Autenticación LDAP
- 2FA habilitado

## Monitoreo

### Métricas de Sistema

- CPU por contenedor
- Memoria utilizada
- I/O de red
- Uso de disco

### Alertas

```yaml
alerts:
  - type: container_down
    severity: high
    notify: ["email", "webhook"]
  - type: high_cpu
    threshold: 90
    duration: 5m
```

## Mantenimiento

### Tareas Automáticas

1. Limpieza de imágenes
2. Pruning de volúmenes
3. Backup de configuración
4. Rotación de logs

### Backups

```bash
# Backup de configuración
tar -czf portainer_config.tar.gz /portainer/data

# Backup de stacks
docker run --rm -v portainer_data:/data \
  -v $(pwd):/backup alpine tar -czf /backup/stacks.tar.gz /data/stacks
```

### Ejemplo de Stack

```yaml
version: '3.8'
services:
  app:
    image: nginx:alpine
    networks:
      - servidor-net
    deploy:
      labels:
        - "traefik.enable=true"
```

## Operaciones

### Templates

- Templates personalizados
- Auto-actualización
- Variables predefinidas
- Stacks compuestos

### Problemas Comunes

1. Problemas de acceso:

   ```bash
   # Verificar logs
   docker logs portainer
   
   # Reiniciar servicio
   docker restart portainer
   ```

### Diagnóstico

- Estado de contenedores
- Logs del sistema
- Métricas activas
- Eventos Docker

### Plan de Recuperación

1. Backup de datos:

   ```bash
   # Backup completo
   docker run --rm -v portainer_data:/data \
     -v $(pwd):/backup alpine tar -czf /backup/portainer_full.tar.gz /data
   
   # Restaurar
   docker run --rm -v portainer_data:/data \
     -v $(pwd):/backup alpine sh -c "rm -rf /data/* && tar -xzf /backup/portainer_full.tar.gz -C /"
   ```

## Mejores Prácticas

### Políticas de Seguridad

- Cambiar contraseña por defecto
- Habilitar 2FA
- Limitar acceso por IP
- Auditar accesos

### Optimización

- Limitar número de contenedores
- Programar pruning
- Monitorear recursos
- Cache de imágenes

### Organización

- Usar etiquetas descriptivas
- Agrupar por stacks
- Documentar cambios
- Gestionar stacks eficientemente
