#!/bin/bash

# Primero iniciamos la red
echo "Iniciando red kronos-net..."
cd networks && docker-compose up -d

# Iniciamos Traefik primero ya que es el proxy inverso
echo "Iniciando Traefik..."
cd ../traefik && docker-compose up -d

# Esperamos unos segundos para que Traefik esté listo
sleep 10

# Iniciamos el resto de los servicios
services=("cloudflare" "pihole" "postie" "immich-app" "plex" "portainer" "transmission" "flexget")

for service in "${services[@]}"; do
    echo "Iniciando $service..."
    cd "../$service" && docker-compose up -d
    sleep 5
done

echo "¡Todos los servicios han sido iniciados!"