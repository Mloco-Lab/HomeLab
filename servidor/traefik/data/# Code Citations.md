# Code Citations

## License: desconocido
https://github.com/Digital-Grinnell/dlad-blog/tree/f1b8682c517e81352e4efa952b10eadb2f0bcacb/content/posts/074-Simplified-Testing-Traefik-2-with-ACME-DNS-01.md

```
/var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/acme.json:/acme.json
    labels:
      - "traefik.enable=
```


## License: desconocido
https://github.com/PAPAMICA/scripts/tree/c1427d0cc97476a52dc582525daa31c3965fc76e/docker-compose/traefik/docker-compose.yml

```
sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/acme.json:/acme.json
    labels:
      - "traefik.enable=true"
      - "traefik.http
```


## License: MIT
https://github.com/KonstantinKlepikov/myknowlegebase/tree/44025b503ffa7691fe76df65c30434137789bd5e/notes/traefik.md

```
etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/acme.json:/acme.json
    labels:
```


## License: desconocido
https://github.com/ClayMav/freyja/tree/2a99746561f7c0ea3e36b07c7302ecf373e1d4f4/traefik/docker-compose.yml

```
env
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/
```

