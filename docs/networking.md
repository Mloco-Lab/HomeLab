# Networking en Servidor

## Arquitectura de Red

### Red Principal

- Nombre: `servidor-net`
- Driver: bridge
- IPv6: habilitado
- IPAM: automático

### Diagrama de Red

```plaintext
Internet
    │
    ├── Router (Puerto 80, 443)
    │   │
    │   └── Traefik (Proxy Inverso)
    │       │
    │       ├── Servicios Web
    │       │   ├── Portainer (9000)
    │       │   ├── Plex (32400)
    │       │   ├── Immich (3001)
    │       │   └── Flexget (5050)
    │       │
    │       └── Servicios de Email
    │           └── Poste.io (25, 465, 587, 993)
    │
    └── Pi-hole (DNS: 53)
```

## Configuración DNS

### Pi-hole

```yaml
# Configuración DNS
dns:
  upstream:
    - 1.1.1.1
    - 1.0.0.1
  local_domains:
    - example.com
    - *.example.com
```

### Resolución Local

```plaintext
# Entradas DNS locales
portainer.example.com -> servidor-net
immich.example.com   -> servidor-net
plex.example.com     -> servidor-net
mail.example.com     -> servidor-net
```

## Seguridad

### Traefik

```yaml
# Configuración de seguridad
security:
  ssl:
    certificates: cloudflare
    min_version: TLS1.2
  headers:
    HSTS: true
    XSS-Protection: true
```

### Firewall

- Puertos expuestos mínimos
- Reglas específicas por servicio
- Bloqueo de puertos no utilizados
- Monitoreo de accesos

## Redes Docker

### Configuración Principal

```yaml
networks:
  servidor-net:
    driver: bridge
    enable_ipv6: true
    ipam:
      config:
        - subnet: 172.20.0.0/16
        - subnet: fd00::/80
```

### Aislamiento

- Servicios web en servidor-net
- Base de datos en red interna
- Redis en red interna
- Comunicación restringida

## Gestión de Tráfico

### Límites de Ancho de Banda

```yaml
# Configuración de QoS
qos:
  plex:
    upload: 50mbps
    download: 100mbps
  transmission:
    upload: 10mbps
    download: 50mbps
```

### Priorización

1. Servicios críticos (email, DNS)
2. Streaming (Plex)
3. Descargas (Transmission)
4. Backups

## Monitoreo

### Métricas

- Tráfico por servicio
- Latencia de red
- Uso de ancho de banda
- Estado de conexiones

### Alertas

```yaml
alerts:
  network:
    - high_latency: >100ms
    - bandwidth_usage: >80%
    - connection_errors: >10/min
```

## Resolución de Problemas

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

## Mantenimiento

### Tareas Periódicas

1. Verificar estado de red
2. Actualizar reglas de firewall
3. Rotar logs de red
4. Optimizar rutas

### Backups

- Configuración de red
- Reglas de firewall
- DNS records
- Certificados SSL

## Mejores Prácticas

### Protección y Seguridad

- Minimizar exposición
- Usar SSL/TLS
- Implementar WAF
- Monitorear accesos

### Rendimiento

- Optimizar rutas
- Balancear carga
- Gestionar caché
- Comprimir tráfico

### Documentación

- Diagramas actualizados
- Registro de cambios
- Procedimientos documentados
- IPs y puertos registrados
