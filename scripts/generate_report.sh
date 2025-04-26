#!/bin/bash

# Script de generación de reportes
# Genera informes detallados del estado del sistema y servicios

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
BASE_DIR="/home/mloco/servidor"
REPORT_DIR="${BASE_DIR}/reports"
DATE=$(date +%Y%m%d)
TIME=$(date +%H%M)
REPORT_FILE="${REPORT_DIR}/${DATE}_${TIME}_report.md"

# Crear directorio de reportes si no existe
mkdir -p "${REPORT_DIR}"

# Función para escribir en el reporte
write_report() {
    echo "$1" >> "${REPORT_FILE}"
}

# Función para obtener estado de servicios
get_services_status() {
    write_report "## Estado de Servicios"
    write_report "\`\`\`"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}" >> "${REPORT_FILE}"
    write_report "\`\`\`"
}

# Función para obtener uso de recursos
get_resource_usage() {
    write_report "## Uso de Recursos"
    
    # CPU
    write_report "### CPU"
    write_report "\`\`\`"
    top -bn1 | head -n 3 >> "${REPORT_FILE}"
    write_report "\`\`\`"
    
    # Memoria
    write_report "### Memoria"
    write_report "\`\`\`"
    free -h >> "${REPORT_FILE}"
    write_report "\`\`\`"
    
    # Disco
    write_report "### Almacenamiento"
    write_report "\`\`\`"
    df -h /mnt/storage >> "${REPORT_FILE}"
    write_report "\`\`\`"
}

# Función para obtener estadísticas de red
get_network_stats() {
    write_report "## Estadísticas de Red"
    write_report "\`\`\`"
    netstat -s | head -n 20 >> "${REPORT_FILE}"
    write_report "\`\`\`"
}

# Función para obtener estado de DNS (Pi-hole)
get_dns_status() {
    write_report "## Estado del DNS (Pi-hole)"
    
    if docker ps | grep -q pihole; then
        write_report "### Estadísticas de Bloqueo"
        write_report "\`\`\`"
        docker exec pihole pihole -c >> "${REPORT_FILE}"
        write_report "\`\`\`"
    else
        write_report "**Pi-hole no está en ejecución**"
    fi
}

# Función para obtener estado de certificados SSL
get_ssl_status() {
    write_report "## Certificados SSL"
    
    if [ -f "${BASE_DIR}/traefik/data/acme.json" ]; then
        write_report "\`\`\`"
        docker exec traefik traefik show certificates >> "${REPORT_FILE}" 2>/dev/null
        write_report "\`\`\`"
    else
        write_report "**Archivo acme.json no encontrado**"
    fi
}

# Función para obtener logs importantes
get_important_logs() {
    write_report "## Logs Relevantes"
    
    for SERVICE in pihole traefik immich-server plex; do
        if docker ps | grep -q $SERVICE; then
            write_report "### $SERVICE"
            write_report "\`\`\`"
            docker logs $SERVICE --tail 20 2>&1 | grep -i "error\|warning" >> "${REPORT_FILE}"
            write_report "\`\`\`"
        fi
    done
}

# Función para obtener estado de respaldos
get_backup_status() {
    write_report "## Estado de Respaldos"
    write_report "\`\`\`"
    ls -lh "${BASE_DIR}/backups/" | tail -n 5 >> "${REPORT_FILE}"
    write_report "\`\`\`"
}

# Función para generar resumen de problemas
generate_summary() {
    local errors=0
    local warnings=0
    
    # Contar errores y advertencias en logs
    errors=$(grep -i "error" "${REPORT_FILE}" | wc -l)
    warnings=$(grep -i "warning" "${REPORT_FILE}" | wc -l)
    
    write_report "## Resumen"
    write_report "- Fecha del reporte: $(date '+%Y-%m-%d %H:%M:%S')"
    write_report "- Errores encontrados: ${errors}"
    write_report "- Advertencias encontradas: ${warnings}"
    
    # Verificar servicios caídos
    local down_services=$(docker ps -a --filter "status=exited" --format "{{.Names}}")
    if [ ! -z "$down_services" ]; then
        write_report "### Servicios Caídos"
        write_report "\`\`\`"
        echo "$down_services" >> "${REPORT_FILE}"
        write_report "\`\`\`"
    fi
}

# Función principal
main() {
    # Iniciar reporte
    write_report "# Reporte del Sistema"
    write_report "Generado el: $(date '+%Y-%m-%d %H:%M:%S')"
    write_report ""
    
    # Generar secciones del reporte
    get_services_status
    write_report ""
    get_resource_usage
    write_report ""
    get_network_stats
    write_report ""
    get_dns_status
    write_report ""
    get_ssl_status
    write_report ""
    get_important_logs
    write_report ""
    get_backup_status
    write_report ""
    generate_summary
    
    echo -e "${GREEN}Reporte generado en: ${REPORT_FILE}${NC}"
}

# Ejecutar reporte
main