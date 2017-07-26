#!/bin/bash

cp -R /source /var/www/html/
cp /Makefile /var/www/html/
cd /var/www/html
make html
mv /var/www/html/build/html/* /var/www/html/
/usr/sbin/httpd -X
