# Resolución de Problemas

## Problemas Comunes y Soluciones

### DNS y Resolución de Nombres

#### Pi-hole No Responde

```bash
# Verificar servicio
docker logs pihole

# Reiniciar DNS
docker exec pihole pihole restartdns

# Verificar resolución
dig @pi-hole example.com
```

#### Problemas de Resolución Local

1. Verificar `/etc/resolv.conf`
2. Comprobar configuración de Pi-hole
3. Verificar registros en Cloudflare

### Servicios Docker

#### Contenedor No Inicia

```bash
# Verificar logs
docker logs <container_name>

# Verificar recursos
docker stats

# Reiniciar contenedor
docker restart <container_name>
```

#### Problemas de Red

```bash
# Verificar redes Docker
docker network ls
docker network inspect servidor-net

# Reconectar contenedor
docker network disconnect servidor-net <container>
docker network connect servidor-net <container>
```

### Almacenamiento

#### Espacio Insuficiente

```bash
# Verificar uso de disco
df -h
du -h --max-depth=1 /mnt/storage

# Limpiar recursos Docker
docker system prune -a
docker volume prune
```

#### Permisos Incorrectos

```bash
# Corregir permisos
chown -R user:group /path
chmod -R 755 /directory
```

### Base de Datos

#### PostgreSQL (Immich)

```bash
# Verificar conexión
docker exec -it immich_postgres psql -U postgres -d immich -c "\l"

# Reparar base de datos
docker exec -it immich_postgres vacuumdb -a -f -z
```

#### SQLite (Flexget)

```bash
# Compactar base de datos
docker exec flexget sqlite3 db-config.sqlite "VACUUM;"
```

### SSL/Certificados

#### Problemas con Certificados

```bash
# Verificar certificados
docker exec traefik traefik show certificates

# Forzar renovación
docker exec traefik traefik show certificates --refresh
```

### Servicios Específicos

#### Immich

1. Problemas de ML

   ```bash
   # Verificar GPU
   nvidia-smi
   # Reiniciar servicio ML
   docker restart immich-machine-learning
   ```

2. Problemas de transcoding

   ```bash
   # Limpiar caché
   rm -rf /mnt/storage/photos/encoded/*
   ```

#### Plex

1. Problemas de biblioteca

   ```bash
   # Escanear biblioteca
   docker exec plex curl http://localhost:32400/library/sections/all/refresh
   ```

2. Problemas de transcoding

   ```bash
   # Limpiar caché de transcoding
   rm -rf /transcode/temp/*
   ```

## Diagnóstico General

### Verificación de Sistema

```bash
# Estado de servicios
docker ps -a

# Uso de recursos
htop
nvidia-smi
df -h

# Logs del sistema
journalctl -xe
```

### Verificación de Red

```bash
# Conectividad
ping -c 4 1.1.1.1
traceroute example.com

# Puertos
netstat -tulpn
ss -tulpn
```

### Herramientas

```bash
# Diagnóstico de red
docker network inspect servidor-net
netstat -tulpn
tcpdump -i any port 80
ping -c 4 portainer.example.com
```

### Problemas Comunes

1. Resolución DNS

   ```bash
   # Verificar DNS
   dig @pi-hole portainer.example.com
   # Limpiar caché DNS
   docker exec pi-hole pihole restartdns
   ```

2. Conectividad

   ```bash
   # Verificar red Docker
   docker network ls
   # Reconectar contenedor
   docker network disconnect servidor-net container
   docker network connect servidor-net container
   ```

## Procedimientos de Recuperación

### Servicios Críticos

1. DNS (Pi-hole)
   - Restaurar desde backup
   - Verificar resolución
   - Comprobar filtrado

2. Proxy (Traefik)
   - Restaurar certificados
   - Verificar rutas
   - Comprobar SSL

### Datos de Usuario

1. Bases de datos
   - Restaurar desde backup
   - Verificar integridad
   - Comprobar datos

2. Archivos multimedia
   - Verificar permisos
   - Comprobar integridad
   - Restaurar metadatos

## Monitoreo y Alertas

### Sistema de Alertas

```yaml
alerts:
  service_down:
    check: "docker ps -a --filter 'status=exited'"
    interval: 5m
    
  disk_space:
    check: "df -h | grep '/mnt/storage'"
    threshold: 90%
    
  memory:
    check: "free -m"
    threshold: 90%
```

### Logs Centralizados

- Recolección centralizada
- Rotación automática
- Análisis de patrones
- Alertas configurables

## Mejores Prácticas

### Preventivo

- Monitoreo proactivo
- Mantenimiento regular
- Respaldos verificados
- Documentación actualizada

### Reactivo

- Plan de respuesta
- Procedimientos documentados
- Herramientas preparadas
- Contactos de emergencia

### Documentación

- Registrar incidentes
- Actualizar soluciones
- Mantener procedimientos
- Compartir conocimiento
