#!/bin/bash

# Script de actualización automatizada para el Servidor
# Realiza actualizaciones seguras con respaldo previo y verificaciones posteriores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Directorio base
BASE_DIR="/home/mloco/servidor"
BACKUP_DIR="${BASE_DIR}/backups/pre-update/$(date +%Y%m%d_%H%M%S)"

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${BASE_DIR}/logs/update.log"
}

# Crear directorio de respaldo
mkdir -p "$BACKUP_DIR"

# Función para respaldar configuraciones
backup_configs() {
    log "Realizando respaldo de configuraciones..."
    
    # Lista de directorios a respaldar
    DIRS=(
        "traefik/data"
        "pihole/etc-pihole"
        "immich-app/config"
        "transmission/transmission"
        "flexget/flexget"
        "postie/config"
    )
    
    for DIR in "${DIRS[@]}"; do
        if [ -d "${BASE_DIR}/${DIR}" ]; then
            log "Respaldando ${DIR}..."
            mkdir -p "${BACKUP_DIR}/$(dirname ${DIR})"
            cp -r "${BASE_DIR}/${DIR}" "${BACKUP_DIR}/${DIR}"
        fi
    done
    
    # Respaldar archivos docker-compose.yml
    find "${BASE_DIR}" -name "docker-compose.yml" -exec cp --parents {} "${BACKUP_DIR}/" \;
    
    log "${GREEN}Respaldo completado en ${BACKUP_DIR}${NC}"
}

# Función para actualizar imágenes Docker
update_images() {
    log "Actualizando imágenes Docker..."
    
    # Lista de servicios
    SERVICES=(
        "traefik"
        "pihole"
        "immich-server"
        "plex"
        "portainer"
        "transmission"
        "flexget"
        "postie"
    )
    
    for SERVICE in "${SERVICES[@]}"; do
        log "Actualizando imagen de ${SERVICE}..."
        docker pull $(docker ps --format '{{.Image}}' | grep ${SERVICE})
    done
    
    log "${GREEN}Actualización de imágenes completada${NC}"
}

# Función para verificar servicios
verify_services() {
    log "Verificando servicios..."
    
    # Esperar a que los servicios estén disponibles
    sleep 30
    
    for SERVICE in $(docker ps --format '{{.Names}}'); do
        if docker ps --format '{{.Names}}' | grep -q "^${SERVICE}$"; then
            log "${GREEN}✓ ${SERVICE} ejecutándose${NC}"
        else
            log "${RED}✗ ${SERVICE} no está ejecutándose${NC}"
            return 1
        fi
    done
    
    return 0
}

# Función para restaurar desde respaldo
restore_backup() {
    log "${RED}Iniciando restauración desde respaldo...${NC}"
    
    # Detener servicios
    cd "${BASE_DIR}" && ./stop-all.sh
    
    # Restaurar archivos
    cp -r "${BACKUP_DIR}"/* "${BASE_DIR}/"
    
    # Reiniciar servicios
    cd "${BASE_DIR}" && ./start-all.sh
    
    log "${GREEN}Restauración completada${NC}"
}

# Función principal
main() {
    log "Iniciando proceso de actualización..."
    
    # Realizar respaldo
    backup_configs
    
    # Detener servicios
    log "Deteniendo servicios..."
    cd "${BASE_DIR}" && ./stop-all.sh
    
    # Actualizar imágenes
    update_images
    
    # Reiniciar servicios
    log "Reiniciando servicios..."
    cd "${BASE_DIR}" && ./start-all.sh
    
    # Verificar servicios
    if verify_services; then
        log "${GREEN}Actualización completada exitosamente${NC}"
    else
        log "${RED}Error en la actualización. Iniciando restauración...${NC}"
        restore_backup
    fi
}

# Manejador de errores
trap 'echo -e "${RED}Error en la actualización. Iniciando restauración...${NC}"; restore_backup; exit 1' ERR

# Ejecutar actualización
main