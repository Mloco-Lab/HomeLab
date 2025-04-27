# Pi-hole

## Descripción General

Servidor DNS con bloqueo de publicidad y filtrado de contenido.

### Ubicación

- Directorio: `/pihole/`
- Configuración: `/etc-pihole/`
- Bases de datos: `/etc-dnsmasq.d/`

### Archivos de Configuración

- `setupVars.conf`: Configuración inicial
- `custom.list`: DNS personalizado
- `04-pihole-static-dhcp.conf`: DHCP estático

### Variables de Entorno

- `WEBPASSWORD`: Contraseña del panel web
- `DNS1`, `DNS2`: DNS upstream
- `REV_SERVER`: DNS reverso

### Puertos

- 53: DNS (TCP/UDP)
- 80: Panel web (HTTP)
- 443: Panel web (HTTPS)

## Configuración DNS

### Resolución DNS

- DNS local prioritario
- Upstream: Cloudflare (1.1.1.1)
- Cache habilitado
- DNSSEC activado

### Gestión

- Actualización automática
- Respaldo diario
- Monitoreo activo
- Registros detallados

### Grupos

- Anuncios
- Malware
- Adult Content
- Social Media
- Custom Lists

### Archivos Respaldados

```plaintext
/etc/pihole/
├── setupVars.conf
├── custom.list
├── dns-servers.conf
└── adlists.list
```

### Programación

- Respaldo diario automático
- Actualización de gravity semanal
- Rotación de logs mensual
- Verificación de integridad

### Panel Web

- Estadísticas en tiempo real
- Gestión de listas negras/blancas
- Consultas recientes
- Top clientes/dominios

### Logs

- Query logging (opcional)
- Tiempo de retención: 30 días
- Rotación automática
- Exportación disponible

### Tareas Automáticas

- Actualización de gravity DB
- Limpieza de caché
- Compactación de FTL
- Backup de configuración

## Mantenimiento

### Actualizaciones

1. Respaldar configuración
2. Actualizar contenedor
3. Verificar funcionalidad
4. Actualizar gravity

### Problemas Comunes

1. Conflictos de puerto 53:

   ```bash
   # Verificar uso del puerto
   sudo lsof -i :53
   
   # Detener systemd-resolved
   sudo systemctl stop systemd-resolved
   ```

### Herramientas de Diagnóstico

- `pihole status`
- `pihole -d`
- `pihole -t`
- `pihole restartdns`

### Restauración

1. Detener contenedor
2. Restaurar backup
3. Verificar permisos
4. Reiniciar servicio

### Verificación

- Comprobar resolución DNS
- Verificar bloqueos
- Revisar estadísticas
- Probar panel web

### Rendimiento

- Optimizar tamaño de caché
- Ajustar tiempo de retención
- Monitorear uso de recursos
- Usar DNSmasq cache
