#!/bin/bash

message_flag=''

while getopts :m: flag
do
    case "${flag}" in
        m) COMMENT=${OPTARG}; message_flag='true' ;;
    esac
done

if  [$message_flag -eq 'true' ]; then
    echo "Enter commit message, followed by [ENTER]: "
    read COMMENT
fi

rm ./doc/index.html
jupyter nbconvert euler-problemset-sage.ipynb --to markdown --output README.md
jupyter nbconvert euler-problemset-sage.ipynb --to slides  --output-dir ./docs/

git add .
git commit -m "${COMMENT}"
git push

exit 0