#!/bin/bash

echo -e 'qual o nome do projeto?'
read name_project

PROJECTS=~/Projetos/pessoais/front-end
FILES_SETUP=$PROJECTS/setup-project/files

# cria diretorio com o nome do projeto
cd $PROJECTS && mkdir $name_project
NEW_PROJECT=$PROJECTS/$name_project

# cria arquivo de source principal com o nome do projeto
cd $NEW_PROJECT
mkdir src && cd src/
touch $name_project.js
cd ..

# copia arquivos pre-configurados
mkdir example
cp $FILES_SETUP/.gitignore .gitignore
cp $FILES_SETUP/Makefile Makefile
cp -R $FILES_SETUP/test/ test

# renomeia arquivos de teste com o nome do projeto
cd test/
mv runner.html runner.$name_project.html
cd spec/
mv spec.js spec.$name_project.js