FROM ubuntu-upstart:14.04
MAINTAINER Hans Kramer
CMD ["/sbin/init"]
RUN apt-get update 
RUN apt-get install -y postgresql-9.3-postgis-2.1 postgresql-contrib-9.3 software-properties-common
RUN add-apt-repository ppa:mapnik/nightly-2.3
RUN add-apt-repository ppa:kakrueger/openstreetmap
RUN apt-get update
RUN apt-get install -y libmapnik libmapnik-dev mapnik-utils python-mapnik mapnik-input-plugin-gdal mapnik-input-plugin-ogr \
                       mapnik-input-plugin-postgis mapnik-input-plugin-sqlite mapnik-input-plugin-osm unifont osm2pgsql
RUN apt-get install -y libpam-systemd:amd64; true
RUN apt-get install -y policykit-1 colord policykit-1-gnome; true
RUN apt-get install -y osmosis; true
RUN /etc/init.d/postgresql start;    \
    su -c "createuser -SdR root;createdb -E UTF8 -O root mapnik;                                               \
           psql -d mapnik -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql postgres;               \
           psql -d mapnik -f /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql postgres;       \
           psql -d mapnik -c 'ALTER TABLE geometry_columns OWNER TO root';                                     \
           psql -d mapnik -c 'ALTER TABLE spatial_ref_sys OWNER TO root'                                       \
          " postgres;                                                                                          \
    sed -i '/^local *all *all *peer$/s/peer/trust/' /etc/postgresql/9.3/main/pg_hba.conf 
