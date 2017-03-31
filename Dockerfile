FROM fedora:25
RUN dnf -y install httpd git make python3-sphinx
RUN mkdir /source
ADD ["Makefile", "/"]
ADD ["build-start.sh", "/"]
WORKDIR /var/www/html
EXPOSE 80
VOLUME /source

CMD "/build-start.sh"