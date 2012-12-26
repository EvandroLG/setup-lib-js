#!/bin/bash

echo -e 'what is the name of the project?'
read NAME_PROJECT

PROJECTS=~/Projetos/pessoais/front-end
FILES_SETUP=$PROJECTSsetup-project/files

cd $PROJECTS && mkdir $NAME_PROJECT
NEW_PROJECT=$PROJECTS/$NAME_PROJECT

cd $NEW_PROJECT
mkdir src && cd src/
touch $NAME_PROJECT.js
cd..

cp $FILES_SETUP/Makefile Makefile
cp $FILES_SETUP/test test