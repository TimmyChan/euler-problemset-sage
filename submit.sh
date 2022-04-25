#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Enter commit message, followed by [ENTER]: "
    read COMMENT
else
	let COMMENT = $1
fi

jupyter nbconvert --to markdown euler-problemset-sage.ipynb --output README.md
jupyter nbconvert --to slides euler-problemset-sage.ipynb --output-dir ./docs/index.html

git add .
git commit -m "$COMMENT"
git push

exit 0