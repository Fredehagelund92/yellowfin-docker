#!/bin/bash -e
export INSTALL_PATH="/opt/yellowfin"
APPSERVER_DIR="$INSTALL_PATH/appserver"

if [ ! -d "$APPSERVER_DIR" ] ; then
  echo "Yellowfin installation not found!"
  echo "  proceeding with automatic installation..."

  java -jar "yellowfin-${YF_MINOR_VER}-${YF_BUILD}-full.jar" -silent install.properties

  if [ -d "$APPSERVER_DIR" ] ; then
    echo "Installation success!"
  else
    echo "Installation failed!"
    exit 1
  fi
fi

echo "Starting Yellowfin..."
"$APPSERVER_DIR/bin/catalina.sh" run