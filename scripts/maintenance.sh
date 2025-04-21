#!/bin/bash

# Script de mantenimiento para Kronos Server
# Ejecuta tareas rutinarias de mantenimiento y monitoreo

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Directorio base
BASE_DIR="/home/mloco/kronos-server"
LOG_DIR="${BASE_DIR}/logs"
BACKUP_DIR="${BASE_DIR}/backups"

# Crear directorios necesarios
mkdir -p "${LOG_DIR}"
mkdir -p "${BACKUP_DIR}"

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_DIR}/maintenance.log"
}

# Verificar espacio en disco
check_disk_space() {
    log "Verificando espacio en disco..."
    
    # Umbral de advertencia (80%)
    THRESHOLD=80
    
    # Obtener uso de disco
    DISK_USAGE=$(df -h /mnt/storage | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
        log "${RED}¡ADVERTENCIA! Uso de disco alto: ${DISK_USAGE}%${NC}"
        return 1
    else
        log "${GREEN}Espacio en disco OK: ${DISK_USAGE}%${NC}"
        return 0
    fi
}

# Verificar servicios Docker
check_services() {
    log "Verificando estado de servicios..."
    
    # Lista de servicios críticos
    SERVICES=("pihole" "traefik" "immich-server" "plex" "portainer" "transmission" "flexget")
    
    for SERVICE in "${SERVICES[@]}"; do
        if docker ps --format '{{.Names}}' | grep -q "$SERVICE"; then
            log "${GREEN}Servicio $SERVICE: Running${NC}"
        else
            log "${RED}Servicio $SERVICE: Stopped${NC}"
            return 1
        fi
    done
    return 0
}

# Limpiar recursos Docker no utilizados
cleanup_docker() {
    log "Limpiando recursos Docker no utilizados..."
    
    # Eliminar contenedores parados
    docker container prune -f
    
    # Eliminar imágenes sin usar
    docker image prune -a -f --filter "until=168h"
    
    # Eliminar volúmenes sin usar
    docker volume prune -f
    
    log "${GREEN}Limpieza de Docker completada${NC}"
}

# Respaldar configuraciones críticas
backup_configs() {
    log "Iniciando respaldo de configuraciones..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="${BACKUP_DIR}/config_backup_${TIMESTAMP}.tar.gz"
    
    # Lista de directorios a respaldar
    DIRS_TO_BACKUP=(
        "traefik/data"
        "pihole/etc-pihole"
        "immich-app/config"
        "transmission/transmission"
        "flexget/flexget"
    )
    
    # Crear respaldo
    for DIR in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "${BASE_DIR}/${DIR}" ]; then
            tar -czf "${BACKUP_FILE}" -C "${BASE_DIR}" "${DIR}"
            log "${GREEN}Respaldo de ${DIR} completado${NC}"
        else
            log "${YELLOW}Directorio ${DIR} no encontrado${NC}"
        fi
    done
}

# Verificar certificados SSL
check_ssl() {
    log "Verificando certificados SSL..."
    
    # Verificar certificados en Traefik
    if [ -f "${BASE_DIR}/traefik/data/acme.json" ]; then
        CERT_INFO=$(docker exec traefik traefik show certificates 2>/dev/null)
        if [ $? -eq 0 ]; then
            log "${GREEN}Certificados SSL OK${NC}"
        else
            log "${RED}Error al verificar certificados SSL${NC}"
            return 1
        fi
    else
        log "${RED}Archivo acme.json no encontrado${NC}"
        return 1
    fi
    return 0
}

# Rotar logs
rotate_logs() {
    log "Rotando logs antiguos..."
    
    find "${LOG_DIR}" -type f -name "*.log" -mtime +7 -delete
    log "${GREEN}Rotación de logs completada${NC}"
}

# Función principal
main() {
    log "Iniciando mantenimiento del sistema..."
    
    # Ejecutar todas las verificaciones
    check_disk_space
    check_services
    check_ssl
    
    # Ejecutar tareas de mantenimiento
    cleanup_docker
    backup_configs
    rotate_logs
    
    log "Mantenimiento completado"
}

# Ejecutar script
main