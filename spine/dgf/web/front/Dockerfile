FROM httpd
ADD WEB /usr/local/apache2/htdocs/
ARG BACKEND_PORT=no 
RUN echo "var BACKEND_PORT = '"${BACKEND_PORT}"'">/usr/local/apache2/htdocs/cfg.js



