function resolve_to_ip {
    echo $(host $1 | awk '/has address/ { print $4 ; exit }')
}

function set_from_proj_name {
    PROJ_NAME=$1
    if [ -z $PROJ_NAME ]; then
        echo "You must supply the project name as an argument"
        return
    fi
    PROJ_PARTS=($(grep $PROJ_NAME ~/.stubproj/projects))
    if [ -z $PROJ_PARTS ]; then
        echo "Couldn't find $PROJ_NAME in ~/.stubproj/projects"
        return
    fi
    PROJ_NAME=${PROJ_PARTS[0]}
    PROJ_HOST=${PROJ_PARTS[1]}
    PROJ_DIR=${PROJ_DIR[2]}
    PROJ_PORT=${PROJ_PARTS[3]}
    echo "PROJ_HOST" $PROJ_HOST
    echo "PROJ_DIR" $PROJ_DIR
    echo "PROJ_NAME" $PROJ_NAME
    echo "PROJ_PORT" $PROJ_PORT
}

function show_usage() {
    echo "stubproj PROJ_NAME PROJ_HOST PROJ_DIR PROJ_PORT"
    echo
    echo "Example:"
    echo "stubproj newproj science6 /grp/jwst/myfolder 9900"
}

function conda_env_exists {
    echo $(conda env list | awk '{ print $1 }' | grep $1 | wc -l)
}
