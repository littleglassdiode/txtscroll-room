#!/bin/bash
# ldt.sh

src="room"
dest="htmlroom"
files="*.md"

function info {
    echo -e "\033[1;32m$1\033[0m"
}

function note {
    echo -e "\033[36m$1\033[0m"
}

function error {
    echo -e "\033[1;31m$1\033[0m"
}

function fatal {
    error "Fatal error; aborting"
    exit 1
}

case $1 in
  help)
    echo -e "\033[1mL\033[0met's \033[1md\033[0mo" \
        "\033[1mt\033[0mhis\033[1;30m.\033[37msh\033[0mit!"
    echo "usage: ldt.sh [subcommand]"
    echo "where subcommand is one of:"
    echo "  build (default): compile the project"
    echo "  clean: remove anything ldt.sh created"
    echo "  help: show this message"
    ;;
  clean)
    info "Let's clean this shit!"
    if [ -d "$dest" ]; then
        bash -xc "rm -r \"$dest\""
    fi
    if [ -f ".ldtsh_last" ]; then
        bash -xc "rm .ldtsh_last"
    fi
    ;;
  build | *)
    info "Let's build this shit!"

    if [ ! -d "$src" ]; then
        error "Source directory not found!"
        fatal
    fi

    if [ ! -d "$dest" ]; then
        note "Destination directory not found; creating it now."
        mkdir "$dest"
    fi

    cwd=$PWD

    last="$cwd/.ldtsh_last"
    cf="last"
    if [ ! -f ".ldtsh_last" ]; then
        cf="f"
    fi

    f="$src"
    if [ "$src" -ot `eval echo \\$$cf` ]; then
        note "No change since last build."
        exit 0
    fi

    cd "$src"
    for f in $files; do
        if [ -f "$f" -a ! `eval echo \\$$cf` -nt "$f" ]; then
            g=`echo "$f" | sed 's/\.md//'`
            cd "$cwd"
            # Okay, yeah, this is a dirty hack, but it gets the job done without
            # having to write the same command twice.
            bash -xc "markdown_py \"$src/$g.md\" -f \"$dest/$g.html\""
            if [ $? -ne 0 ]; then
                error "Build error!"
                fatal
            fi
            cd "$src"
        fi
    done

    cd "$cwd"
    touch .ldtsh_last
    ;;
esac
