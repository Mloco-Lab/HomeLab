# Cloudflare

## Descripción General
Cloudflare proporciona servicios de DNS, CDN y seguridad para Kronos Server. Se integra con Traefik para la gestión de certificados SSL y ofrece protección DDoS.

## Configuración

### Ubicación
- Directorio: `/cloudflare/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - Token API en archivo seguro

### Variables de Entorno
```plaintext
CF_API_TOKEN=<token>
CF_ZONE_API_TOKEN=<token>
CF_API_EMAIL=<email>
```

## DNS

### Registros Principales
```yaml
# Registros A
example.com:
  - type: A
    name: "@"
    content: <IP-ADDRESS>
    proxied: true

# Subdominios
subdomains:
  - portainer
  - plex
  - immich
  - transmission
  - flexget
  - mail
```

### CNAME Records
```yaml
www:
  - type: CNAME
    name: "www"
    content: "example.com"
    proxied: true
```

## Seguridad

### Certificados SSL
- Modo: Full (strict)
- Validación: DNS
- Renovación automática
- Wildcard habilitado

### Firewall
```yaml
firewall_rules:
  - description: "Bloquear países no permitidos"
    expression: not(ip.geoip.country in {"ES" "US"})
    action: block

  - description: "Limitar acceso admin"
    expression: (http.request.uri.path contains "/admin")
    action: challenge
```

## DNS sobre HTTPS

### Configuración
```yaml
dns_over_https:
  enabled: true
  endpoints:
    - https://cloudflare-dns.com/dns-query
```

### Validación
- DNSSEC habilitado
- DNS CAA configurado
- DMARC implementado

## CDN y Caché

### Reglas de Caché
```yaml
cache_rules:
  - description: "Caché estático"
    expression: http.request.uri.path matches "^/static/.*"
    settings:
      edge_ttl: 2h
      browser_ttl: 1h

  - description: "No cachear dinámico"
    expression: http.request.uri.path matches "^/api/.*"
    settings:
      cache: false
```

### Optimización
- Auto-minify habilitado
- Brotli compression
- HTTP/3 (QUIC)
- Early Hints

## Monitoreo

### Métricas
- Tráfico DNS
- Amenazas bloqueadas
- Rendimiento CDN
- Estado SSL

### Alertas
```yaml
alerts:
  - type: ssl_expiration
    threshold: 7d
    notify: true

  - type: ddos_attack
    threshold: medium
    notify: true
```

## Resolución de Problemas

### Problemas Comunes
1. Certificados SSL:
   ```bash
   # Verificar estado
   curl -I https://example.com
   # Purgar caché
   curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache"
   ```

2. DNS:
   ```bash
   # Verificar propagación
   dig +short @1.1.1.1 example.com
   # Verificar DNSSEC
   dig +dnssec example.com
   ```

### Diagnóstico
- Logs de acceso
- Estado de servicios
- Tiempo de propagación
- Validación SSL

## Mantenimiento

### Tareas Rutinarias
1. Verificar certificados
2. Actualizar reglas
3. Revisar analytics
4. Optimizar caché

### Respaldos
- Configuración DNS
- Reglas de firewall
- Certificados SSL
- Tokens API

## Mejores Prácticas

### Seguridad
- Rotar tokens regularmente
- Implementar 2FA
- Monitorear accesos
- Mantener registros

### Rendimiento
- Optimizar reglas
- Gestionar caché
- Configurar Page Rules
- Usar Workers cuando sea necesario

### Documentación
- Mantener registros DNS
- Documentar cambios
- Registrar incidentes
- Actualizar procedimientos