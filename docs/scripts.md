# Scripts de Mantenimiento y Monitoreo

## Scripts Disponibles

### maintenance.sh
Script de mantenimiento general del sistema.

#### Funcionalidades
- Verificación de espacio en disco
- Monitoreo de servicios
- Limpieza de recursos Docker
- Respaldo de configuraciones
- Verificación de certificados SSL
- Rotación de logs

#### Ejecución
```bash
./scripts/maintenance.sh
```

#### Programación
Se ejecuta automáticamente todos los días a las 2 AM vía cron.

### monitor.sh
Monitor en tiempo real del sistema.

#### Funcionalidades
- Estadísticas del sistema (CPU, memoria, disco)
- Estado de contenedores Docker
- Verificación de servicios críticos
- Estadísticas de red
- Logs recientes

#### Ejecución
```bash
./scripts/monitor.sh
```

#### Uso
- Ctrl+C para salir
- Se actualiza cada 5 segundos
- Muestra alertas en tiempo real

### generate_report.sh
Generador de informes del sistema.

#### Funcionalidades
- Estado completo de servicios
- Uso de recursos
- Estadísticas de red
- Estado de DNS (Pi-hole)
- Estado de certificados SSL
- Logs importantes
- Estado de respaldos
- Resumen de problemas

#### Ejecución
```bash
./scripts/generate_report.sh
```

#### Programación
Se ejecuta automáticamente dos veces al día:
- 8:00 AM
- 8:00 PM

### update.sh
Script de actualización del sistema.

#### Funcionalidades
- Respaldo pre-actualización
- Actualización de imágenes Docker
- Verificación post-actualización
- Restauración automática en caso de fallo

#### Ejecución
```bash
./scripts/update.sh
```

### check_status.sh
Verificación rápida del estado del sistema.

#### Funcionalidades
- Estado de servicios Docker
- Uso de recursos
- Puertos en uso
- Estado de redes
- Estado de volúmenes
- Logs recientes

#### Ejecución
```bash
./scripts/check_status.sh
```

## Ubicación de Archivos

### Scripts
Todos los scripts se encuentran en el directorio `/scripts/`:
```plaintext
scripts/
├── maintenance.sh
├── monitor.sh
├── generate_report.sh
├── update.sh
└── check_status.sh
```

### Logs
Los logs se almacenan en `/logs/`:
```plaintext
logs/
├── maintenance.log
├── monitor.log
└── update.log
```

### Reportes
Los reportes generados se almacenan en `/reports/` con el formato:
```plaintext
YYYYMMDD_HHMM_report.md
```

## Mantenimiento de Scripts

### Verificación
- Comprobar permisos de ejecución
- Verificar cron jobs
- Revisar rotación de logs
- Validar directorios de salida

### Actualización
1. Respaldar script actual
2. Aplicar cambios
3. Verificar permisos
4. Probar funcionamiento
5. Actualizar documentación

### Troubleshooting

#### Permisos
```bash
chmod +x scripts/*.sh
```

#### Cron Jobs
```bash
crontab -l
```

#### Logs
```bash
tail -f logs/maintenance.log
```

## Mejores Prácticas

### Seguridad
- Ejecutar con privilegios mínimos
- Validar entradas
- Manejar errores
- Proteger información sensible

### Mantenimiento
- Comentar código
- Mantener consistencia
- Documentar cambios
- Respaldar configuraciones

### Monitoreo
- Verificar ejecución
- Revisar logs
- Validar salidas
- Actualizar alertas