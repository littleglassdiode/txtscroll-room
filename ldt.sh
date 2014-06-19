#!/bin/sh
# ldt.sh

src="room"
dest="htmlroom"
files="*.md"
md="markdown_py"

ldt=${1:-build}

info() {
    printf "\033[1;32m$1\033[0m\n"
}

note() {
    printf "\033[36m$1\033[0m\n"
}

fatal() {
    printf "\033[1;31m$1\033[0m\n"
    printf "\033[1;31mFatal error; aborting\033[0m\n"
    exit 1
}

pexec() {
    printf "\t$*\n"
    $*
}

ldtlast=".ldtsh_last"

case $ldt in
  help)
    printf "\033[1mL\033[0met's \033[1md\033[0mo "
    printf "\033[1mt\033[0mhis\033[1;30m.\033[37ms\033[0mtuff "
    printf "\033[1mh\033[0mere!\n"
    printf "usage: ldt.sh [subcommand]\n"
    printf "where subcommand is one of:\n"
    printf "  build (default): compile the project\n"
    printf "  clean: remove anything ldt.sh created\n"
    printf "  help: show this message\n"
    ;;
  clean)
    info "Let's clean this stuff here!"
    if [ -d "$dest" ]; then
        pexec rm -r "$dest"
    fi
    if [ -f "$ldtlast" ]; then
        pexec rm "$ldtlast"
    fi
    ;;
  build)
    info "Let's build this stuff here!"

    if [ ! -d "$src" ]; then
        fatal "Source directory not found!"
    fi

    if [ ! -d "$dest" ]; then
        note "Destination directory not found; creating it now."
        mkdir "$dest"
    fi

    cwd=$PWD

    last="$cwd/$ldtlast"
    cf="last"
    if [ ! -f "$ldtlast" ]; then
        cf="f"
    fi

    f="$src"
    if [ "$src" -ot $(eval echo '$'$cf) ]; then
        note "No change since last build."
        exit 0
    fi

    cd "$src"
    for f in $files; do
        # if it's a regular file that has been changed since last build
        if [ -f "$f" -a ! $(eval echo '$'$cf) -nt "$f" ]; then
            filename="${f%.*}"
            cd "$cwd"
            # Okay, yeah, this is a dirty hack, but it gets the job done without
            # having to write the same command twice.
            pexec $md "$src/$filename.md" -f "$dest/$filename.html"
            if [ $? -ne 0 ]; then
                fatal "Build error!"
            fi
            cd "$src"
        fi
    done

    cd "$cwd"
    touch $ldtlast
    ;;
esac
