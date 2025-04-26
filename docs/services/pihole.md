# Pi-hole

## Descripción General
Pi-hole funciona como servidor DNS y bloqueador de anuncios a nivel de red para todo el sistema. Se integra con systemd-resolved y proporciona filtrado DNS avanzado.

## Configuración

### Ubicación
- Directorio: `/pihole/`
- Directorios principales:
  - `etc-pihole/`: Configuración principal
  - `etc-dnsmasq.d/`: Configuración de DNS
  - `bkp/`: Respaldos automáticos

### Archivos de Configuración
- `setupVars.conf`: Configuración inicial
- `pihole.toml`: Configuración principal
- `custom.list`: DNS personalizado
- `adlists.list`: Listas de bloqueo

### Variables de Entorno
- `WEBPASSWORD`: Contraseña del panel web
- `TZ`: Zona horaria
- `DNSSEC`: Estado de DNSSEC
- `DNS1`/`DNS2`: Servidores DNS upstream

### Puertos
- 53: DNS (TCP/UDP)
- 80: Interfaz web
- 443: HTTPS (opcional)

## Integración con systemd-resolved

### Configuración
```toml
# Configuración para evitar conflictos de puerto
DNSStubListener=no
DNS=127.0.0.1
DNSSEC=yes
```

### Resolución DNS
- DNS local prioritario
- Caché DNS
- Resolución de nombres internos

## Listas de Bloqueo

### Gestión
- Actualización automática
- Personalización por dominio
- Whitelist/Blacklist

### Grupos
- Anuncios
- Malware
- Trackers
- Contenido adulto

## Sistema de Respaldo

### Archivos Respaldados
```plaintext
/etc/pihole/
├── gravity.db
├── custom.list
├── adlists.list
├── pihole-FTL.db
└── setupVars.conf
```

### Programación
- Respaldo diario automático
- Retención de 7 días
- Compresión de archivos

## Monitoreo

### Panel Web
- Estadísticas en tiempo real
- Consultas DNS
- Dominios bloqueados
- Clientes activos

### Logs
- Query logging (opcional)
- FTL logging
- Rotación automática

## Mantenimiento

### Tareas Automáticas
- Actualización de gravity DB
- Limpieza de caché
- Rotación de logs
- Compactación de bases de datos

### Actualizaciones
1. Respaldar configuración
2. Actualizar contenedor
3. Verificar listas de bloqueo
4. Comprobar resolución DNS

## Resolución de Problemas

### Problemas Comunes
1. Conflictos de puerto 53:
   ```bash
   # Verificar uso del puerto
   sudo lsof -i :53
   # Detener systemd-resolved si necesario
   sudo systemctl stop systemd-resolved
   ```

2. Fallos de resolución DNS:
   ```bash
   # Verificar funcionamiento
   dig @127.0.0.1 google.com
   # Comprobar logs
   docker logs pihole
   ```

### Herramientas de Diagnóstico
- `pihole status`
- `pihole -d` (debug)
- `pihole -t` (tail logs)
- `pihole -up` (update)

## Recuperación

### Restauración
1. Detener contenedor
2. Copiar archivos de respaldo
3. Restaurar permisos
4. Reiniciar servicio

### Verificación
- Comprobar resolución DNS
- Verificar listas de bloqueo
- Confirmar estadísticas

## Mejores Prácticas

### Seguridad
- Cambiar contraseña por defecto
- Limitar acceso al panel web
- Mantener respaldos actualizados
- Usar HTTPS para el panel

### Rendimiento
- Optimizar tamaño de caché
- Limitar logging excesivo
- Mantener listas de bloqueo actualizadas
- Usar DNSmasq cache