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
jupyter nbconvert euler-problemset-sage.ipynb --to slides  --output-dir ./docs/ --SlidesExporter.reveal_theme=dark


git add .
git commit -m "${COMMENT}"
git push

exit 0