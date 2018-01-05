#!/bin/bash -e

git config user.name "${GH_USER_NAME}"
git config user.email "{GH_USER_EMAIL}"

if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    # Get current hash
    GIT_HASH=`git rev-parse HEAD`

    # Build
    #mvn clean install exec:java

    # Update Website
    echo $SSH_KEY | base64 -d > web_ssh_keys
    chmod 600 web_ssh_keys
    export GIT_SSH_COMMAND="ssh -v -i $PWD/web_ssh_keys"

    git clone git@github.com:stianst/keycloak.github.io.git

    cd keycloak.github.io

    rm -rf *.html archive resources

    cp -r ../target/web/* .

    git add --all
    git commit -m "Updated to $GIT_HASH"
    git -v push

    rm web_ssh_keys
fi