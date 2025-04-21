# Poste.io

## Descripción General
Poste.io es una solución completa de servidor de correo que incluye servicios SMTP, IMAP, POP3, y una interfaz web de administración. Está diseñado para ser fácil de configurar y mantener.

## Servicios

### Componentes Principales
1. Postfix (SMTP)
2. Dovecot (IMAP/POP3)
3. Roundcube (Webmail)
4. ClamAV (Antivirus)
5. SpamAssassin (Anti-spam)
6. OpenDKIM (Autenticación)

## Configuración

### Ubicación
- Directorio: `/postie/`
- Archivos principales:
  - `docker-compose.yml`: Configuración del contenedor
  - Volúmenes persistentes para datos y configuración

### Puertos
```plaintext
SMTP:
- 25: SMTP entrante
- 465: SMTP sobre SSL
- 587: SMTP con STARTTLS

IMAP:
- 143: IMAP
- 993: IMAPS (SSL)

POP3:
- 110: POP3
- 995: POP3S (SSL)

Web:
- 80: HTTP (redirigido a HTTPS)
- 443: HTTPS
```

### DNS Records
```plaintext
MX:
  @ IN MX 10 mail.kronos.cloudns.ph.

A/AAAA:
  mail IN A <IP-ADDRESS>

TXT:
  @ IN TXT "v=spf1 mx ~all"
  _dmarc IN TXT "v=DMARC1; p=reject; rua=mailto:postmaster@kronos.cloudns.ph"
```

## Seguridad

### SSL/TLS
- Certificados gestionados por Traefik
- Forzar SSL/TLS en todos los servicios
- STARTTLS habilitado

### Anti-spam
```yaml
spamassassin:
  required_score: 5.0
  rewrite_header:
    Subject: "[SPAM] "
  report_safe: 0
```

### Antivirus
- Escaneo en tiempo real
- Actualización automática de firmas
- Cuarentena configurable

## Autenticación

### DKIM
```plaintext
Selector: mail
Bits: 2048
Domain: kronos.cloudns.ph
```

### SPF
- Strict mode
- Limitar a IPs autorizadas
- Monitoreo de fallos

### DMARC
- Política: reject
- Reportes habilitados
- Subdomains incluidos

## Mantenimiento

### Respaldos
1. Correos
   ```bash
   /var/mail/
   /var/vmail/
   ```

2. Configuración
   ```bash
   /etc/postfix/
   /etc/dovecot/
   ```

3. Base de datos
   ```bash
   /var/lib/mysql/
   ```

### Logs
- Mail logs
- Auth logs
- Spam logs
- Error logs

## Monitoreo

### Métricas
- Correos enviados/recibidos
- Tasa de spam
- Uso de almacenamiento
- Estado de colas

### Alertas
- Errores de entrega
- Espacio bajo
- Blacklisting
- Fallos de autenticación

## Resolución de Problemas

### Problemas Comunes
1. Problemas de entrega:
   ```bash
   # Verificar cola
   postqueue -p
   
   # Forzar envío
   postqueue -f
   ```

2. Problemas de autenticación:
   ```bash
   # Verificar logs
   tail -f /var/log/mail.log
   ```

### Diagnóstico
- Verificar registros DNS
- Comprobar blacklists
- Revisar logs
- Test de conexión

## Recuperación

### Plan de Recuperación
1. Respaldar datos
2. Restaurar configuración
3. Verificar DNS
4. Probar servicios

### Verificación
- SMTP entrante/saliente
- IMAP/POP3
- Webmail
- Antivirus/Spam

## Mejores Prácticas

### Configuración
- Límites de tamaño
- Políticas de retención
- Cuotas de usuario
- Filtros de contenido

### Seguridad
- Actualizaciones regulares
- Monitoreo de reputación
- Backups cifrados
- Acceso restringido

### Rendimiento
- Optimizar caché
- Gestionar colas
- Limpiar logs
- Mantener índices