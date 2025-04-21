#!/bin/bash

# Script de verificación de estado del sistema Kronos
# Proporciona una vista general del estado de todos los servicios y recursos

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para imprimir encabezado
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Verificar estado de servicios Docker
check_docker_services() {
    print_header "Estado de Servicios Docker"
    
    # Lista de servicios críticos
    declare -A SERVICES=(
        ["traefik"]="Proxy Inverso"
        ["pihole"]="DNS y Bloqueo de Anuncios"
        ["immich-server"]="Servidor de Fotos"
        ["immich-machine-learning"]="ML para Fotos"
        ["plex"]="Servidor Multimedia"
        ["portainer"]="Gestión Docker"
        ["transmission"]="Cliente Torrent"
        ["flexget"]="Automatización"
        ["postie"]="Servidor de Correo"
    )
    
    for SERVICE in "${!SERVICES[@]}"; do
        if docker ps --format '{{.Names}}' | grep -q "$SERVICE"; then
            echo -e "${GREEN}✓${NC} ${SERVICE} (${SERVICES[$SERVICE]}): Running"
        else
            echo -e "${RED}✗${NC} ${SERVICE} (${SERVICES[$SERVICE]}): Stopped"
        fi
    done
}

# Verificar uso de recursos
check_resources() {
    print_header "Uso de Recursos"
    
    # CPU
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    echo -e "CPU: ${CPU_USAGE}%"
    
    # Memoria
    MEM_INFO=$(free -h)
    echo -e "Memoria:\n$MEM_INFO"
    
    # Disco
    echo -e "\nUso de Disco:"
    df -h /mnt/storage
}

# Verificar puertos
check_ports() {
    print_header "Puertos en Uso"
    
    declare -A PORTS=(
        [80]="HTTP"
        [443]="HTTPS"
        [53]="DNS"
        [9000]="Portainer"
        [32400]="Plex"
        [9091]="Transmission"
        [5050]="Flexget"
        [25]="SMTP"
        [465]="SMTPS"
        [993]="IMAPS"
    )
    
    for PORT in "${!PORTS[@]}"; do
        if netstat -tuln | grep -q ":$PORT "; then
            echo -e "${GREEN}✓${NC} Puerto $PORT (${PORTS[$PORT]}): Abierto"
        else
            echo -e "${RED}✗${NC} Puerto $PORT (${PORTS[$PORT]}): Cerrado"
        fi
    done
}

# Verificar estado de redes Docker
check_networks() {
    print_header "Redes Docker"
    docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"
}

# Verificar estado de volúmenes
check_volumes() {
    print_header "Volúmenes Docker"
    docker volume ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"
}

# Verificar logs recientes
check_logs() {
    print_header "Logs Recientes (últimas 5 líneas por servicio)"
    
    for SERVICE in $(docker ps --format '{{.Names}}'); do
        echo -e "\n${YELLOW}=== $SERVICE ===${NC}"
        docker logs --tail 5 $SERVICE 2>&1
    done
}

# Función principal
main() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}     Kronos Server - Reporte de Estado      ${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo -e "Fecha: $(date '+%Y-%m-%d %H:%M:%S')\n"
    
    check_docker_services
    check_resources
    check_ports
    check_networks
    check_volumes
    check_logs
    
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}            Reporte Completado              ${NC}"
    echo -e "${BLUE}============================================${NC}"
}

# Ejecutar reporte
main