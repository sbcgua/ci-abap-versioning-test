#!/bin/bash
VERSION_FILE=src/zif_abapgit_version.intf.abap

git diff-tree --no-commit-id --name-only -r HEAD | grep $VERSION_FILE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no version change detected, skipping tag creation"
    exit 0
fi

VERSION_DIFF=`git diff HEAD^:$VERSION_FILE HEAD:$VERSION_FILE`

echo "$VERSION_DIFF" | grep gc_abap_version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no version change detected, skipping tag creation"
    exit 0
fi

VERSION_BEFORE=$(echo "$VERSION_DIFF" | grep '^-.\+\bgc_abap_version\b' | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')
VERSION_AFTER=$(echo "$VERSION_DIFF" | grep '^+.\+\bgc_abap_version\b' | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')

if [ -z $VERSION_BEFORE ] || [ -z $VERSION_AFTER ]; then
    echo "unexpected version parsing error"
    echo "$VERSION_DIFF" | grep gc_abap_version
    exit 1
fi

if [ $VERSION_BEFORE = $VERSION_AFTER ]; then
    echo "no version change detected, skipping tag creation"
    exit 0
fi

echo "version change detected [$VERSION_BEFORE > $VERSION_AFTER], creating a new tag ..."
TAG="v$VERSION_AFTER"

# DEPLOY

openssl aes-256-cbc -K $encrypted_d04247868aac_key -iv $encrypted_d04247868aac_iv -in deploy-key.enc -out deploy-key -d
chmod 600 deploy-key
eval $(ssh-agent -s)
ssh-add deploy-key

git config user.email "builds@travis-ci.com"
git config user.name "Travis CI"

REPO_PATH=git remote -v | grep -m1 '^origin' | sed -Ene 's#.*(https://[^/]+/([^/]+/[^/.]+)).*#\2#p'
REPO_SSH_URL="git@github.com:$REPO_PATH.git"
echo "Pushing to $REPO_SSH_URL"
git remote set-url origin $REPO_SSH_URL

git tag $TAG || exit 1
git push origin $TAG || exit 1
