# Traefik

## Descripción General
Traefik actúa como el punto de entrada principal para todos los servicios web en el Servidor. Gestiona el enrutamiento, los certificados SSL y la seguridad básica.

## Configuración

### Ubicación
- Directorio: `/traefik/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - `data/traefik.yml`: Configuración principal de Traefik
  - `data/acme.json`: Almacenamiento de certificados SSL

### Variables de Entorno
- `CF_API_TOKEN`: Token de API de Cloudflare
- `CF_API_EMAIL`: Email asociado a la cuenta de Cloudflare
- `CF_ZONE_API_TOKEN`: Token para gestión de zonas DNS

### Puertos
- 80: HTTP (redirección a HTTPS)
- 443: HTTPS
- 8080: Panel de administración (protegido)

## Integración con Cloudflare

### DNS
- Gestión automática de registros DNS
- Validación de certificados mediante DNS Challenge
- Soporte para wildcards

### Seguridad
- Protección DDoS
- WAF básico
- Rate limiting configurado

## Certificados SSL

### Gestión Automática
- Proveedor: Let's Encrypt
- Método: DNS Challenge vía Cloudflare
- Renovación automática 30 días antes del vencimiento

### Almacenamiento
- Archivo: `data/acme.json`
- Permisos: 600 (solo lectura por propietario)
- Respaldo automático en `data/acme.json.bkp`

## Middlewares

### Seguridad
```yaml
# Ejemplo de configuración de seguridad
headers:
  SSLRedirect: true
  STSSeconds: 315360000
  BrowserXSSFilter: true
  ContentTypeNosniff: true
  ForceSTSHeader: true
```

### Redirecciones
- HTTP a HTTPS automático
- www a non-www (configurable)
- Paths personalizados por servicio

## Monitoreo

### Dashboard
- URL: `dashboard.example.com`
- Autenticación requerida
- Métricas en tiempo real

### Logs
- Nivel: INFO (configurable)
- Rotación: 7 días
- Formato: JSON para mejor integración

## Mantenimiento

### Actualizaciones
1. Respaldar `acme.json`
2. Actualizar imagen de Docker
3. Verificar certificados
4. Comprobar rutas

### Resolución de Problemas
- Verificar logs: `docker logs traefik`
- Comprobar certificados: `docker exec traefik traefik show certs`
- Validar configuración: `docker exec traefik traefik validate`

## Recuperación

### Respaldo
```bash
# Archivos a respaldar
- data/traefik.yml
- data/acme.json
- docker-compose.yml
- cf_api_token.txt
```

### Restauración
1. Detener Traefik
2. Restaurar archivos de configuración
3. Restaurar certificados
4. Reiniciar servicio

## Mejores Prácticas

### Seguridad
- Mantener tokens seguros
- Usar autenticación en dashboard
- Limitar acceso a puertos de administración

### Rendimiento
- Habilitar compresión
- Configurar buffers adecuadamente
- Usar caché cuando sea posible