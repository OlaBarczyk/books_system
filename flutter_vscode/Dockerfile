# Używamy oficjalnego obrazu Nginx
FROM nginx:alpine

# Kopiujemy statyczne pliki Fluttera do katalogu Nginx
COPY ./build/web /usr/share/nginx/html

# Kopiujemy własną konfigurację Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
