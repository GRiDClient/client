#!/bin/bash

base=`pwd`

function cleanup {
    for patch in *.patch; do
        gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
        diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index)")

        testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
        if [ "x$testver" != "x" ]; then
            diffs=$(echo "$diffs" | head -n -2)
        fi
        

        if [ "x$diffs" == "x" ] ; then
            git reset HEAD $patch >/dev/null
            git checkout -- $patch >/dev/null
        fi
    done
}

function save {
	cd "../src/minecraft/"
	git format-patch --no-start -N -o "$base" master
	cd "../../"
	git add -A "$basedir"
	echo "Patches have been saved!"
}

if [ "$1" == "clean" ]; then
	cd ".."
	rm -rf "$base"
fi

save