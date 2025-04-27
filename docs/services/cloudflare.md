# Cloudflare$
$
## DescripciM-CM-3n General$
$
Cloudflare proporciona servicios de DNS, CDN y seguridad para el Servidor. Se integra con Traefik para la gestiM-CM-3n de certificados SSL y ofrece protecciM-CM-3n DDoS.$
$
## ConfiguraciM-CM-3n Principal$
$
### UbicaciM-CM-3n$
$
- Directorio: `/cloudflare/`$
- Archivos principales:$
  - `docker-compose.yml`: ConfiguraciM-CM-3n del contenedor$
  - Token API en archivo seguro$
$
### Variables de Entorno$
$
```plaintext$
CF_API_TOKEN=<token>$
CF_ZONE_API_TOKEN=<token>$
CF_API_EMAIL=<email>$
```$
$
## DNS$
$
### Registros Principales$
$
```yaml$
# Registros A$
example.com:$
  - type: A$
    name: "@"$
    content: <IP-ADDRESS>$
    proxied: true$
$
# Subdominios$
subdomains:$
  - portainer$
  - plex$
  - immich$
  - transmission$
  - flexget$
  - mail$
```$
$
### CNAME Records$
$
```yaml$
www:$
  - type: CNAME$
    name: "www"$
    content: "example.com"$
    proxied: true$
```$
$
## ProtecciM-CM-3n y Seguridad$
$
### Certificados SSL$
$
- Modo: Full (strict)$
- ValidaciM-CM-3n: DNS$
- RenovaciM-CM-3n automM-CM-!tica$
- Wildcard habilitado$
$
### Firewall$
$
```yaml$
firewall_rules:$
  - description: "Bloquear paM-CM--ses no permitidos"$
    expression: not(ip.geoip.country in {"ES" "US"})$
    action: block$
$
  - description: "Limitar acceso admin"$
    expression: (http.request.uri.path contains "/admin")$
    action: challenge$
```$
$
## DNS sobre HTTPS$
$
### Ajustes DNS$
$
```yaml$
dns_over_https:$
  enabled: true$
  endpoints:$
    - https://cloudflare-dns.com/dns-query$
```$
$
### ValidaciM-CM-3n$
$
- DNSSEC habilitado$
- DNS CAA configurado$
- DMARC implementado$
$
## CDN y CachM-CM-)$
$
### Reglas de CachM-CM-)$
$
```yaml$
cache_rules:$
  - description: "Estaticos"$
    expression: (http.request.uri.path matches "^/static/.*")$
    cache_ttl: 86400$
```$
$
### OptimizaciM-CM-3n$
$
- Auto-minify habilitado$
- Brotli compression$
- HTTP/3 (QUIC)$
- Early Hints$
$
## Monitoreo$
$
### MM-CM-)tricas$
$
- TrM-CM-!fico DNS$
- Uso de cachM-CM-)$
- Amenazas bloqueadas$
- Latencia global$
$
### Alertas$
$
```yaml$
alerts:$
  - type: "ddos_attack"$
    severity: "high"$
    notification: "email"$
  - type: "ssl_expiry"$
    severity: "critical"$
    notification: "email,webhook"$
```$
$
## ResoluciM-CM-3n de Problemas$
$
### Problemas Comunes$
$
1. Certificados SSL:$
$
   ```bash$
   # Verificar estado SSL$
   curl -vI https://example.com$
   $
   # Forzar renovaciM-CM-3n$
   docker restart cloudflared$
   ```$
$
### DiagnM-CM-3stico$
$
- Logs de acceso$
- Analytics$
- Trace routes$
- SSL/TLS tests$
$
## Mantenimiento$
$
### Tareas Rutinarias$
$
1. Verificar certificados$
2. Actualizar reglas$
3. Revisar analytics$
4. Optimizar cachM-CM-)$
$
### Respaldos$
$
- ConfiguraciM-CM-3n DNS$
- Reglas de firewall$
- Page rules$
- Workers$
$
### PolM-CM--ticas de Seguridad$
$
- Rotar tokens regularmente$
- Actualizar allowlists$
- Revisar reglas WAF$
- Monitorear amenazas$
$
### Rendimiento$
$
- Optimizar reglas$
- Ajustar cachM-CM-)$
- Revisar analM-CM--ticas$
- Actualizar workers$
$
### DocumentaciM-CM-3n$
$
- Mantener registros DNS$
- Documentar cambios$
- Actualizar diagramas$
- Registrar incidentes$
