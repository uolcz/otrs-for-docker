FROM ubuntu:xenial

MAINTAINER  UOL <tech@uol.cz>

# Dependencies
RUN apt-get update && apt-get install -y \ 
  libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl \
  libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl libtext-csv-xs-perl \
  libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl \
  libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl \
  libtemplate-perl libdbd-pg-perl libdigest-md5-perl curl apache2 libdatetime-timezone-perl \
  postgresql-9.5

# PostgreSQL
USER postgres
RUN  /etc/init.d/postgresql start &&\
    psql --command "CREATE USER otrs WITH SUPERUSER PASSWORD 'mysecretpassword';" &&\
    createdb -O otrs otrs

USER root

# OTRS source
RUN curl -fsSL "http://ftp.otrs.org/pub/otrs/otrs-6.0.0.beta1.tar.gz" \
    | tar -xzC "/opt"

RUN mv /opt/otrs-* /opt/otrs

# OTRS User
RUN useradd -d /opt/otrs -c 'OTRS user' otrs
RUN usermod -G www-data otrs

# Apache2 configuration
RUN a2enmod perl
RUN a2enmod deflate
RUN a2enmod filter
RUN a2enmod headers
RUN echo 'ServerName localhost' > /etc/apache2/sites-available/zzz_otrs.conf
RUN cat /opt/otrs/scripts/apache2-httpd.include.conf >> /etc/apache2/sites-available/zzz_otrs.conf
RUN a2dissite 000-default
RUN a2ensite zzz_otrs
RUN service apache2 restart

WORKDIR /opt/otrs/

# Default OTRS Config
COPY Config.pm Kernel/Config.pm

# Correct Permissions
RUN bin/otrs.SetPermissions.pl --web-group=www-data

EXPOSE "80"

COPY otrs-start.sh otrs-start.sh
RUN chmod 700 otrs-start.sh
CMD ./otrs-start.sh
