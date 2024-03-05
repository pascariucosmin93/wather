# Folosim imaginea oficială Nginx ca bază
FROM nginx:1.25.4

# Exponăm portul 80 pentru a putea accesa serverul web
EXPOSE 80

# Copiem fișierele HTML și CSS în directorul de lucru al serverului web Nginx
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# Încheiem cu comanda pentru a porni serverul Nginx atunci când containerul este lansat
CMD ["nginx", "-g", "daemon off;"]
