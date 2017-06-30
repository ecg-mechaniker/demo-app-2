FROM nginx:alpine

ADD index.html frames.html content.html /usr/share/nginx/html/
