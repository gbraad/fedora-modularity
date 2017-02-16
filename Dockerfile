FROM fedora
RUN dnf -y install httpd git make
RUN dnf -y install python3-sphinx
RUN mkdir /source
ADD ["Makefile", "/"]
ADD ["build-start.sh", "/"]
WORKDIR /var/www/html
EXPOSE 80
VOLUME /source

CMD "/build-start.sh"