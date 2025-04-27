# Traefik

## Descripción General

Proxy inverso que gestiona el enrutamiento de servicios y la terminación SSL/TLS, integrado con Docker y Cloudflare.

## Configuración Base

### Ubicación

- Directorio: `/traefik/`
- Configuración: `/data/traefik.yml`
- Certificados: `/data/acme.json`

### Variables de Entorno

- `CF_API_TOKEN`: Token de API de Cloudflare
- `CF_ZONE_ID`: ID de zona DNS
- `CF_EMAIL`: Email de cuenta

### Puertos

- 80: HTTP (redirección a HTTPS)
- 443: HTTPS
- 8080: Dashboard (interno)

## Integración con Cloudflare

### DNS

- Gestión automática de registros DNS
- Validación de certificados mediante DNS Challenge
- Soporte para wildcards
- Cache DNS configurado

### Protección

- Protección DDoS
- WAF básico
- Rate limiting
- IP Filtering

## Certificados SSL

### Gestión Automática

- Proveedor: Let's Encrypt
- Método: DNS Challenge
- Renovación automática
- Wildcard habilitado

### Almacenamiento

- Archivo: `data/acme.json`
- Permisos: 600
- Respaldo automático
- Rotación segura

## Configuración de Servicios

### Middleware

```yaml
middlewares:
  secure-headers:
    headers:
      sslRedirect: true
      forceSTSHeader: true
      stsSeconds: 31536000
      stsIncludeSubdomains: true
  
  rate-limit:
    rateLimit:
      average: 100
      burst: 50
```

### Redirecciones

- HTTP a HTTPS automático
- WWW a non-WWW
- Paths personalizados
- Error pages

## Monitoreo

### Dashboard

- URL: `dashboard.example.com`
- Acceso protegido
- Métricas en tiempo real
- Estado de servicios

### Logs

- Nivel: INFO (configurable)
- Formato: JSON
- Rotación diaria
- Retención: 30 días

## Mantenimiento

### Actualizaciones

1. Respaldar `acme.json`
2. Actualizar imagen
3. Verificar config
4. Reiniciar servicio

### Resolución de Problemas

- Verificar logs: `docker logs traefik`
- Validar config
- Probar conectividad
- Verificar DNS

## Respaldo y Recuperación

### Respaldo

```bash
# Backup de configuración
tar -czf traefik_backup.tar.gz /traefik/data/

# Respaldo de certificados
cp /traefik/data/acme.json /traefik/data/acme.json.bak
```

### Restauración

1. Detener Traefik
2. Restaurar configs
3. Verificar permisos
4. Reiniciar servicio

## Mejores Prácticas

### Políticas de Seguridad

- Mantener tokens seguros
- Actualizar certificados
- Monitorear accesos
- Limitar endpoints

### Optimización

- Habilitar compresión
- Configurar buffers
- Ajustar timeouts
- Usar caché cuando sea posible
