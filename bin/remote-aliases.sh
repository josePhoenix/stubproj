function localproj {
    if [ -z $1 ]; then
        echo "usage: localproj PROJ_NAME"
        return
    fi
    if [ -z $(which conda) ]; then
        echo "conda command not in \$PATH, aborting"
        return
    fi
    if [ ! -e ~/workspace/"$PROJ_NAME" ]; then
        echo "No workspace link to project '$PROJ_NAME'"
        return
    fi

    source activate $1
    cd ~/workspace/"$1"
}

function localprojnb {
    if [ -z $1 ]; then
        echo "usage: localprojnb PROJ_NAME"
        return
    fi
    if [ -z $(which conda) ]; then
        echo "conda command not in \$PATH, aborting"
        return  
    fi
    PROJ_NAME="$1"
    if [ ! -e ~/workspace/"$PROJ_NAME" ]; then
        echo "No workspace link to project '$PROJ_NAME'"
        return
    fi

    localproj "$PROJ_NAME"
    if [ -e ./circus/notebook.pid ]; then
        pid=`cat ./circus/notebook.pid`
        has_pid=1
    else
        has_pid=0
    fi
    if [ $has_pid -ne 0 ] && [ -e /proc/$pid -a /proc/$pid/exe ]; then
        echo "Notebook for $PROJ_NAME already started as PID $pid"
    else
        circusd --daemon ./circus/circus.ini
        sleep 2
        echo "Started notebook for $PROJ_NAME (pid: $(cat ./circus/notebook.pid))"
    fi
}

function localprojnboff {
    if [ -z $1 ]; then
        echo "usage: localprojnboff PROJ_NAME"
        return
    fi
    PROJ_NAME="$1"
    if [ ! -e ~/workspace/"$PROJ_NAME" ]; then
        echo "No workspace link to project '$PROJ_NAME'"
        return
    fi

    localproj "$PROJ_NAME"
    if [ -e ./circus/notebook.pid ]; then
        pid=`cat ./circus/notebook.pid`
        has_pid=1
    else
        has_pid=0
    fi
    if [ $has_pid -ne 0 ] && [ -e /proc/$pid -a /proc/$pid/exe ]; then
        kill $pid
    else
        rm -f ./circus/notebook.pid
        echo "Notebook for $PROJ_NAME was not running"
    fi
}
