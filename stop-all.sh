#!/bin/bash

# Detenemos los servicios en orden inverso
services=("flexget" "transmission" "portainer" "plex" "immich-app" "postie" "pihole" "cloudflare")

for service in "${services[@]}"; do
    echo "Deteniendo $service..."
    cd "$service" && docker-compose down
    cd ..
    sleep 5
done

# Detenemos Traefik al final
echo "Deteniendo Traefik..."
cd traefik && docker-compose down
cd ..

# Finalmente detenemos la red
echo "Deteniendo red kronos-net..."
cd networks && docker-compose down

echo "¡Todos los servicios han sido detenidos!"