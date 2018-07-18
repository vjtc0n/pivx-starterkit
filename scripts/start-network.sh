#!/bin/sh
set -x

EXECUTABLE=/usr/local/bin/pivxd
DIR=$HOME/.pivx
FILENAME=pivx.conf
FILE=$DIR/$FILENAME

# create directory and config file if it does not exist yet
if [ ! -e "$FILE" ]; then
    mkdir -p $DIR

    echo "Creating $FILENAME"

    # Seed a random password for JSON RPC server
    cat <<EOF > $FILE
printtoconsole=${PRINTTOCONSOLE:-1}
rpcbind=127.0.0.1
server=1
rpcuser=${RPCUSER:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
EOF

fi

ls -lah /usr/local/bin/pivxd

echo "Initialization completed successfully"

exec $EXECUTABLE