#!/bin/bash
# ldt.sh

src="room"
dest="htmlroom"
files="*.md"

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

echo -e "\033[1mL\033[0met's \033[1md\033[0mo" \
    "\033[1mt\033[0mhis\033[1;30m.\033[37msh\033[0mit!"

if ( ! test -d "$src" )
then
    error "Source directory not found!"
    fatal
fi

if ( ! test -d "$dest" )
then
    note "Destination directory not found; creating it now."
    mkdir "$dest"
fi

cwd=$PWD

cf="$cwd/.ldtsh_last"
if ( ! test -f ".ldtsh_last" )
then
    cf="$f"
fi

cd "$src"
for f in $files
do
    if ( test -f "$f" && test "$cf" -ot "$f" )
    then
        g=`echo "$f" | sed 's/\.md//'`
        cd "$cwd"
        echo "markdown_py \"$src/$g.md\" -f \"$dest/$g.html\""
        markdown_py "$src/$g.md" -f "$dest/$g.html"
        cd "$src"
    fi
done

cd "$cwd"
touch .ldtsh_last
