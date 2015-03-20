#! /bin/bash
#
# \author    Hans Kramer
# \date      March 2015
#

DID=$(docker run -d -v ~hans/src/mapnik-schiphol:/home mapnik-tools-v2.3:latest)
[ "$1" = "-s" ] && docker exec -it $DID bash
