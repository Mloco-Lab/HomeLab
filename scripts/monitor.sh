#!/bin/bash

# Script de monitoreo para el Servidor
# Monitorea recursos y servicios en tiempo real

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
UPDATE_INTERVAL=5  # segundos
LOG_FILE="/home/mloco/servidor/logs/monitor.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEM=80
ALERT_THRESHOLD_DISK=80

# Asegurar que existe el directorio de logs
mkdir -p "$(dirname "$LOG_FILE")"

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Función para mostrar el banner
show_banner() {
    clear
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}       Monitor del Servidor v1.0           ${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
}

# Función para obtener estadísticas del sistema
get_system_stats() {
    # CPU
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    
    # Memoria
    MEM_INFO=$(free -m | grep Mem)
    MEM_TOTAL=$(echo "$MEM_INFO" | awk '{print $2}')
    MEM_USED=$(echo "$MEM_INFO" | awk '{print $3}')
    MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))
    
    # Disco
    DISK_USAGE=$(df -h /mnt/storage | tail -1 | awk '{print $5}' | sed 's/%//')
}

# Función para mostrar estadísticas de Docker
show_docker_stats() {
    echo -e "\n${BLUE}Estado de Contenedores:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}"
}

# Función para mostrar estadísticas del sistema
show_system_stats() {
    get_system_stats
    
    echo -e "\n${BLUE}Estadísticas del Sistema:${NC}"
    echo -e "CPU: ${CPU_USAGE}%"
    echo -e "Memoria: ${MEM_USAGE}%"
    echo -e "Disco: ${DISK_USAGE}%"
    
    # Colorear según umbrales
    if [ "$CPU_USAGE" -gt "$ALERT_THRESHOLD_CPU" ]; then
        log "${RED}¡Alerta! Uso de CPU alto: ${CPU_USAGE}%${NC}"
    fi
    if [ "$MEM_USAGE" -gt "$ALERT_THRESHOLD_MEM" ]; then
        log "${RED}¡Alerta! Uso de memoria alto: ${MEM_USAGE}%${NC}"
    fi
    if [ "$DISK_USAGE" -gt "$ALERT_THRESHOLD_DISK" ]; then
        log "${RED}¡Alerta! Uso de disco alto: ${DISK_USAGE}%${NC}"
    fi
}

# Función para mostrar logs recientes
show_recent_logs() {
    echo -e "\n${BLUE}Logs Recientes:${NC}"
    tail -n 5 "$LOG_FILE"
}

# Función para verificar servicios críticos
check_critical_services() {
    echo -e "\n${BLUE}Servicios Críticos:${NC}"
    
    SERVICES=("pihole" "traefik" "immich-server" "plex" "portainer")
    
    for SERVICE in "${SERVICES[@]}"; do
        if docker ps --format '{{.Names}}' | grep -q "$SERVICE"; then
            echo -e "${GREEN}✓ $SERVICE${NC}"
        else
            echo -e "${RED}✗ $SERVICE${NC}"
            log "${RED}¡Alerta! Servicio $SERVICE no está ejecutándose${NC}"
        fi
    done
}

# Función para mostrar estadísticas de red
show_network_stats() {
    echo -e "\n${BLUE}Estadísticas de Red:${NC}"
    echo "Conexiones activas:"
    netstat -n | grep ESTABLISHED | wc -l
    
    echo -e "\nPuertos en uso:"
    netstat -tulpn | grep LISTEN
}

# Función principal de monitoreo
monitor() {
    while true; do
        show_banner
        show_system_stats
        show_docker_stats
        check_critical_services
        show_network_stats
        show_recent_logs
        
        echo -e "\n${YELLOW}Actualizando en $UPDATE_INTERVAL segundos... (Ctrl+C para salir)${NC}"
        sleep $UPDATE_INTERVAL
    done
}

# Manejador de señales
trap 'echo -e "\n${YELLOW}Deteniendo monitoreo...${NC}"; exit 0' SIGINT SIGTERM

# Iniciar monitoreo
monitor