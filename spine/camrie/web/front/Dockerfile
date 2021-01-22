FROM httpd
ADD WEB /usr/local/apache2/htdocs/
ARG BACKEND=no 
RUN echo "var BACKEND = '"${BACKEND}"'">/usr/local/apache2/htdocs/cfg.js



