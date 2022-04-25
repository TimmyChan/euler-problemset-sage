#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Enter commit message, followed by [ENTER]: "
    read COMMENT
else
	let COMMENT = $1
fi

jupyter nbconvert euler-problemset-sage.ipynb --to markdown --output README.md
jupyter nbconvert euler-problemset-sage.ipynb --to slides  --output-dir ./docs/index.html

git add .
git commit -m "$COMMENT"
git push

exit 0