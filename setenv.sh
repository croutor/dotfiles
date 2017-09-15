#!/bin/sh
#
# V 01.00.03 - 12 December 2002
# 05-Mar-2005 : add multiple installation paths
# --------------------------------------------------------------------------------------

order=1
order_include=1
#INSTALL_DIR=/local/bin:/local/sbin

if [ $# = 1 ]; then
    INSTALL_DIR=$1
else
    #INSTALL_DIR=/local/bin:/local/sbin:/local/opt
    INSTALL_DIR=/home/vhe/stow
fi
	
# For zsh shell:
# emulate sh

function set_env()
{
    if [ -d $dir/bin ]; then
        if [ $order = 1 ]; then
	    PATH=$dir/bin:$PATH
	else
            PATH=$PATH:$dir/bin
        fi
    fi

    if [ -d $dir/sbin ]; then
        if [ $order = 1 ]; then
	    PATH=$dir/sbin:$PATH
	else
            PATH=$PATH:$dir/sbin
        fi
    fi

    if [ -d $dir/lib ]; then
        if [ $order = 1 ]; then
            LD_LIBRARY_PATH=$dir/lib:$LD_LIBRARY_PATH
            LD_RUN_PATH=$dir/lib:$LD_RUN_PATH	    
    	    #LIBRARY_PATH=$dir/lib:$LIBRARY_PATH
	else
            LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$dir/lib
            LD_RUN_PATH=$LD_RUN_PATH:$dir/lib
    	    #LIBRARY_PATH=$LIBRARY_PATH:$dir/lib
	fi
    fi   
    
    # --- pkgconfig ---
    if [ -d $dir/lib/pkgconfig ]; then
        PKG_CONFIG_PATH=$dir/lib/pkgconfig:$PKG_CONFIG_PATH
    fi

    if [ -d $dir/share/pkgconfig ]; then
        PKG_CONFIG_PATH=$dir/share/pkgconfig:$PKG_CONFIG_PATH
    fi
    
    if [ -d $dir/man ]; then
        if [ $order = 1 ]; then
            MANPATH=$dir/man:$MANPATH
	else
            MANPATH=$MANPATH:$dir/man
	fi
    fi

    if [ -d $dir/share/man ]; then
        if [ $order = 1 ]; then
            MANPATH=$dir/share/man:$MANPATH
	else
            MANPATH=$MANPATH:$dir/share/man
	fi
    fi
    
    if [ -d $dir/info ]; then
        if [ $order = 1 ]; then
            INFOPATH=$dir/info:$INFOPATH
	else
            INFOPATH=$INFOPATH:$dir/info
	fi
    fi
    
    if [ 1 = 1 ] && [ -d $dir/include ]; then
        if [ "$CPATH" = "" ]; then
	        CPATH=$dir/include
        elif [ $order_include = 1 ]; then
	        CPATH=$dir/include:$CPATH
	else
  	    CPATH=$CPATH:$dir/include
	fi
    fi
    
    if [ -d $dir/lib/python2.4/site-packages ]; then
        PYTHONPATH=$dir/lib/python2.4/site-packages:$PYTHONPATH
    fi
}

function uniq_path()
{
    eval X=\$$1
    echo $X
    #eval $1=$(echo $X | tr ':' '\n' | awk '{if ($0 != "") print NR" "$0}' | sort +1 -t\ | uniq -1 | sort -n | cut -f2 -d\  | tr '\n' ':')
    #eval $1=$(echo $X | tr ':' '\n' | awk '{if ($0 != "") print NR" "$0}' | sort +1 -t\ | uniq -1 | sort -n | cut -f2 -d\  | tr '\n' ':' | sed "s/\(.*\):$/\1/g" )
    eval $1=$(echo $X | tr ':' '\n' | awk '{if ($0 != "") print NR" "$0}' | sort +1 -t\ | uniq -1 | sort -n | cut -f2 -d\  | tr '\n' ':' | sed "s/\(.*\):$/\1/g")
    echo $1 
}


function uniq_path_()
{
    # Removes duplicate entries from path. Protects the path from growing too big
    # during multiple invocations of bash.

    eval X=\$$1

    eval $1=$(echo $X | awk -F: '
    {
        for (i = 1; i <= NF; i++)
	arr[$i];
    }
    END {
        for (i in arr)
	    printf "%s:" , i;
	printf "\n";
    } ')
    
    # Remove any : at end
    eval X=\$$1
    if [ "$X[-1]" = ":" ]; then
        eval $1=$X[0,-2]
    fi
    
    # Remove any : at begining
    eval X=\$$1
    if [ "$X[1]" = ":" ]; then
        eval $1=$X[2,-1]
    fi
    
    #echo $X
}


saved_IFS=$IFS
IFS=:
for install_dir in $INSTALL_DIR #/opt /opt/Gnu
do
    IFS=$saved_IFS
    echo -n $install_dir":"
    for dir in `/usr/bin/find $install_dir -maxdepth 1 -type l -print ` ; do
        #if echo $dir | egrep -q '.*/[A-Za-z][A-Za-z0-9]*$' ; then
        set_env $dir
        #fi
    done
done
IFS=$saved_IFS
echo

#CPATH=/usr/include:$CPATH

#uniq_path CPATH
#uniq_path INFOPATH
#uniq_path LD_LIBRARY_PATH
#uniq_path LD_RUN_PATH
#uniq_path LIBRARY_PATH
#uniq_path MANPATH
#uniq_path PATH
#uniq_path PKG_CONFIG_PATH
#uniq_path PYTHONPATH

#typeset -U PATH
#typeset -U LD_LIBRARY_PATH
#typeset -U LIBRARY_PATH
#typeset -U CPATH
#typeset -U MANPATH
#typeset -U INFOPATH

GST_PLUGIN_PATH=/local/bin/gst-plugins-farsight/lib/gstreamer-0.10
export GST_PLUGIN_PATH
export CPATH
export INFOPATH
export LD_LIBRARY_PATH
export LD_RUN_PATH
export LIBRARY_PATH
export MANPATH
export PATH
export PKG_CONFIG_PATH
export XDG_DATA_DIRS
export PYTHONPATH
#LD_RUN_PATH

#echo $PATH
