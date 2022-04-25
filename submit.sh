#!/bin/bash

message_flag=false

while getopts "m:" flag
do
    case "${flag}" in
        m) COMMENT=${OPTARG}; message_flag=true ;;
    esac
done

if  [ !${message_flag} ]; then
    echo "Enter commit message, followed by [ENTER]: "
    read COMMENT
fi


jupyter nbconvert euler-problemset-sage.ipynb --to markdown --output README.md
jupyter nbconvert euler-problemset-sage.ipynb --to slides  --output-dir ./docs/
mv -f ./docs/euler-problemset-sage.slides.html index.html


git add .
git commit -m "${COMMENT}"
git push

exit 0