#!/bin/bash
git diff-tree --no-commit-id --name-only -r HEAD | grep abapgit

if [ $? -ne 0 ]; then
    echo "no version change detected, skipping tag creation"
    exit 0
fi
echo $?




