# Sistema de Respaldos

## Estrategia de Respaldo

### Niveles de Respaldo
1. **Crítico**
   - Pi-hole DNS
   - Traefik SSL
   - Bases de datos
   - Configuraciones

2. **Importante**
   - Correo electrónico
   - Metadatos de media
   - Logs del sistema
   - Estados de servicios

3. **Datos de Usuario**
   - Bibliotecas multimedia
   - Fotos y videos
   - Documentos
   - Descargas completadas

## Programación

### Respaldos Automáticos
```yaml
schedules:
  critical:
    frequency: daily
    retention: 7
    time: "03:00"
    
  important:
    frequency: weekly
    retention: 4
    time: "04:00"
    
  user_data:
    frequency: monthly
    retention: 12
    time: "05:00"
```

## Directorios a Respaldar

### Sistema
```plaintext
/home/xxxx/servidor/
├── */docker-compose.yml
├── */config/
├── */.env
└── */data/
```

### Datos
```plaintext
/mnt/storage/
├── media/
│   ├── movies/
│   ├── tv/
│   └── music/
├── photos/
├── downloads/
└── backups/
```

## Scripts de Respaldo

### backup_system.sh
```bash
#!/bin/bash
# Respaldo del sistema
backup_configs() {
    tar -czf configs.tar.gz /home/xxxx/servidor/*/config/
}

backup_databases() {
    # PostgreSQL
    pg_dump -U postgres immich > immich.sql
    
    # SQLite
    sqlite3 flexget.db ".backup 'flexget_backup.db'"
}

backup_certificates() {
    cp -r /traefik/data/acme.json /backups/ssl/
}
```

### backup_data.sh
```bash
#!/bin/bash
# Respaldo de datos
backup_media() {
    rsync -av --delete /mnt/storage/media/ /backups/media/
}

backup_mail() {
    tar -czf mail.tar.gz /var/mail/
}
```

## Políticas de Retención

### Rotación de Respaldos
```yaml
retention:
  daily:
    keep_last: 7
    compress: true
    
  weekly:
    keep_last: 4
    compress: true
    
  monthly:
    keep_last: 12
    compress: true
    encrypt: true
```

### Limpieza
```bash
# Eliminar respaldos antiguos
find /backups/daily -type f -mtime +7 -delete
find /backups/weekly -type f -mtime +28 -delete
find /backups/monthly -type f -mtime +365 -delete
```

## Verificación

### Tests de Integridad
```bash
# Verificar respaldos
check_backup() {
    tar -tf archivo.tar.gz > /dev/null
    echo $? # Debe ser 0
}

# Verificar base de datos
test_database() {
    psql -f backup.sql --list
}
```

### Restauración de Prueba
- Restaurar en entorno de prueba
- Verificar integridad
- Validar funcionamiento
- Documentar resultado

## Restauración

### Procedimiento
1. Detener servicios
   ```bash
   ./stop-all.sh
   ```

2. Restaurar configs
   ```bash
   tar -xzf configs.tar.gz -C /
   ```

3. Restaurar datos
   ```bash
   rsync -av /backups/media/ /mnt/storage/media/
   ```

4. Restaurar bases de datos
   ```bash
   psql -U postgres immich < immich.sql
   ```

5. Reiniciar servicios
   ```bash
   ./start-all.sh
   ```

## Seguridad

### Encriptación
```yaml
encryption:
  algorithm: AES-256-CBC
  key_management: vault
  verify: true
```

### Acceso
- Permisos restrictivos
- Autenticación requerida
- Logs de acceso
- Alertas de modificación

## Monitoreo

### Estado de Respaldos
```yaml
monitoring:
  check_frequency: 15m
  metrics:
    - last_backup_time
    - backup_size
    - success_rate
    - storage_usage
```

### Alertas
```yaml
alerts:
  - backup_failed
  - integrity_check_failed
  - storage_low
  - backup_missing
```

## Mejores Prácticas

### Seguridad
- Cifrar datos sensibles
- Almacenar fuera del sitio
- Verificar regularmente
- Documentar procedimientos

### Eficiencia
- Usar respaldos incrementales
- Comprimir archivos
- Optimizar programación
- Automatizar procesos

### Documentación
- Mantener registros
- Documentar cambios
- Registrar restauraciones
- Actualizar procedimientos