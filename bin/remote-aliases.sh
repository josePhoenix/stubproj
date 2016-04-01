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
    if [ -e ./notebook.pid ]; then
        pid=`cat ./notebook.pid`
        has_pid=1
    else
        has_pid=0
    fi
    if [ $has_pid -ne 0 ] && [ -e /proc/$pid -a /proc/$pid/exe ]; then
        echo "Notebook for $PROJ_NAME already started as PID $pid"
    else
        jupyter notebook --config=./jupyter_notebook_config
    fi
}
