# Diagramas de Arquitectura del Servidor

## Diagrama de Red

```mermaid
graph TD
    subgraph Red Servidor
        Router[Router] --> Traefik[Traefik]
        Router --> Pihole[Pi-hole]
        
        Traefik --> Web[Servicios Web]
        Traefik --> Mail[Servicios Mail]
        
        Web --> Portainer[Portainer]
        Web --> Plex[Plex]
        Web --> Immich[Immich]
        
        Mail --> Postie[Poste.io]
    end
```

## Flujo de Datos

```mermaid
sequenceDiagram
    participant U as Usuario
    participant T as Traefik
    participant S as Servicio
    participant D as Base de Datos
    participant St as Almacenamiento
    
    U->>T: Solicitud HTTPS
    T->>T: Verificar SSL
    T->>S: Proxy Request
    S->>D: Consulta
    D-->>S: Respuesta
    S->>St: Guardar/Leer datos
    St-->>S: Datos
    S-->>T: Respuesta
    T-->>U: Respuesta HTTPS
```

## Estructura de Red

```mermaid
graph TB
    subgraph Red Externa
        Internet((Internet))
        CF[Cloudflare]
    end
    
    subgraph servidor-net
        TR[Traefik]
        PH[Pi-hole]
        
        subgraph Servicios Web
            IM[Immich]
            PL[Plex]
            PO[Portainer]
            PS[Poste.io]
        end
        
        subgraph Servicios Backend
            DB[(Bases de Datos)]
            RD[(Redis)]
            ML[Machine Learning]
        end
        
        subgraph Automatización
            TS[Transmission]
            FG[Flexget]
        end
    end
    
    Internet --> CF
    CF --> TR
    TR --> Servicios Web
    Servicios Web --> Servicios Backend
```

## Sistema de Respaldos

```mermaid
graph LR
    subgraph Fuentes
        Config[Configuraciones]
        Data[Datos]
        DB[(Bases de Datos)]
    end
    
    subgraph Scripts
        Daily[Respaldo Diario]
        Weekly[Respaldo Semanal]
        Monthly[Respaldo Mensual]
    end
    
    subgraph Almacenamiento
        Local[/mnt/storage/backups/]
        Remote[Almacenamiento Remoto]
    end
    
    Config --> Daily
    Data --> Weekly
    DB --> Daily
    
    Daily --> Local
    Weekly --> Local
    Monthly --> Remote
```

## Monitoreo y Alertas

```mermaid
graph TB
    subgraph Fuentes de Datos
        Logs[Logs de Servicios]
        Metrics[Métricas del Sistema]
        Events[Eventos de Docker]
    end
    
    subgraph Procesamiento
        Monitor[Scripts de Monitoreo]
        Analysis[Análisis de Logs]
    end
    
    subgraph Notificaciones
        Alert[Sistema de Alertas]
        Dashboard[Dashboard Portainer]
    end
    
    Logs --> Monitor
    Metrics --> Monitor
    Events --> Monitor
    
    Monitor --> Analysis
    Analysis --> Alert
    Analysis --> Dashboard
```
