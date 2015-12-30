#!/bin/bash

function die()
{
    echo $*
    exit 1
}

function link()
{
    if [[ -h $1 ]]; then
        if ((FORCE)); then
            die "Not replacing existing symlink $1"
        fi
        rm -f $1 || die "Can't remove existing symlink $1"
        echo "Removed existing symlink $1"
    elif [[ -f $1 ]]; then
        if ((FORCE)); then
            die "Not replacing existing file $1"
        fi
        mv $1 $1.bak || die "Can't move $1 to $1.bak"
        echo "Moved $1 to $1.bak"
    fi
    ln -s $2 $1 || die "Can't create symlink from $1 to $2"
    echo "Linked: $1 -> $2"
}

function create()
{
    if [[ ! -f $1 ]]; then
        touch $1 || die "Can't create empty $1"
    fi
    echo "Created: $1"
}

function linkdot()
{
    link ~/.$1 $TARGETDIR/$1
    create ~/.$1.local
}

while (($#)); do
    case $1 in
        -f)
            FORCE=1
            ;;
        *)
            die "Unknown argument $1"
            ;;
    esac
    shift
done

TARGETDIR=$(cd ${0%%/*} && pwd)
linkdot bashfunctions
linkdot inputrc
linkdot vimrc
