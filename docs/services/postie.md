# Poste.io

## Descripción General

Servidor de correo completo con soporte IMAP/SMTP y webmail.

### Componentes Principales

1. Postfix (SMTP)
2. Dovecot (IMAP/POP3)
3. Rspamd (Anti-spam)
4. ClamAV (Antivirus)

### Ubicación

- Directorio: `/postie/`
- Datos: `/data/`
- Configuración: `/config/`

### Puertos

```plaintext
25   - SMTP
465  - SMTPS
587  - Submission
993  - IMAPS
995  - POP3S
```

### DNS Records

```plaintext
mail.example.com.    IN A     xxx.xxx.xxx.xxx
example.com.         IN MX 10 mail.example.com.
_dmarc               IN TXT   "v=DMARC1; p=reject; rua=mailto:admin@example.com"
```

### SSL/TLS

- Certificados gestionados por Traefik
- TLS 1.2/1.3 habilitado
- STARTTLS requerido
- Perfect Forward Secrecy

### Anti-spam

```yaml
rspamd:
  actions:
    reject: 15
    add_header: 6
    greylist: 4
  checks:
    - spf
    - dkim
    - dmarc
    - rbl
```

### Antivirus

- Escaneo en tiempo real
- Actualización automática
- Cuarentena integrada
- Notificaciones configurables

### DKIM

```plaintext
selector._domainkey.example.com. IN TXT "v=DKIM1; k=rsa; p=MII..."
```

### SPF

- Strict mode
- include:_spf.example.com
- ip4:xxx.xxx.xxx.xxx
- ~all

### DMARC

- Política: reject
- Reportes: `admin@example.com`
- Subdomains: yes
- Porcentaje: 100

## Operaciones

### Respaldos

1. Correos

   ```bash
   # Backup de correos
   tar -czf maildir_backup.tar.gz /data/vmail
   
   # Backup de configuración
   tar -czf config_backup.tar.gz /config
   
   # Backup de base de datos
   docker exec postie mysqldump -u root mailserver > db_backup.sql
   ```

### Logs

- Mail logs
- Authentication logs
- Spam/virus logs
- Access logs

### Métricas

- Correos enviados/recibidos
- Spam detectado
- Virus bloqueados
- Uso de almacenamiento

### Alertas

- Errores de entrega
- Intentos de spam
- Detecciones de virus
- Espacio insuficiente

### Problemas Comunes

1. Problemas de entrega:

   ```bash
   # Verificar cola
   docker exec postie postqueue -p
   
   # Forzar envío
   docker exec postie postqueue -f
   ```

### Diagnóstico

- Verificar registros DNS
- Comprobar certificados
- Revisar blacklists
- Testear conexiones

### Plan de Recuperación

1. Respaldar datos
2. Detener servicios
3. Restaurar desde backup
4. Verificar integridad

### Verificación

- SMTP entrante/saliente
- IMAP/POP3 acceso
- Webmail funcional
- Filtros activos

### Mantenimiento

- Limpieza periódica
- Optimización de índices
- Rotación de logs
- Actualización de firmas

### Seguridad

- Actualizaciones regulares
- Monitoreo de accesos
- Backups cifrados
- Políticas estrictas

### Rendimiento

- Optimizar caché
- Ajustar recursos
- Mantener índices
- Limpiar colas
