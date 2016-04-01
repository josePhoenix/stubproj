function do_remotely {
    PROJ_HOST=$1
    CMD=$2
    echo "PROJ_HOST=$PROJ_HOST"
    ssh "$PROJ_HOST" -t "bash --rcfile <(echo '. ~/.bashrc; $CMD')"
}

function proj {
    PROJ_NAME=$1
    PROJ_PARTS=($(grep $PROJ_NAME ~/.stubproj_list))
    if [ -z $PROJ_PARTS ]; then
        echo "Couldn't find $PROJ_NAME in ~/.stubproj_list"
        return
    fi
    PROJ_HOST=${PROJ_PARTS[1]}
    do_remotely $PROJ_HOST "localproj $PROJ_NAME"
}

function projnb {
    PROJ_NAME=$1
    PROJ_PARTS=($(grep $PROJ_NAME ~/.stubproj_list))
    if [ -z $PROJ_PARTS ]; then
        echo "Couldn't find $PROJ_NAME in ~/.stubproj_list"
        return
    fi
    PROJ_HOST=${PROJ_PARTS[1]}
    PROJ_PORT=${PROJ_PARTS[2]}
    echo "PROJ_HOST=$PROJ_HOST"
    echo "PROJ_PORT=$PROJ_PORT"

    (sleep 3; open "http://$PROJ_HOST:$PROJ_PORT/") & \
        do_remotely $PROJ_HOST "localprojnb $PROJ_NAME"
}
