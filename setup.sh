#!/bin/bash
# ferramenta command line para startar projeto de novo componente javascript, com os arquivos comumente usados
# author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
# https://github.com/evandrolg
# License: MIT

# varre todos os parametros passados na execução do programa
while test -n "$1"
do
	case "$1" in
      -n | --name ) # 
			shift
			name_project="$1"
		;;

		-j | --jquery )
			tem_jquery=1
		;;
	esac
	shift
done

PROJECTS=~/Projetos/pessoais/front-end
FILES_SETUP=$PROJECTS/setup-project/files

# cria diretorio com o nome do projeto
cd $PROJECTS 
mkdir $name_project
NEW_PROJECT=$PROJECTS/$name_project

# cria arquivo de source principal com o nome do projeto
cd $NEW_PROJECT
mkdir src 
cd src/
touch $name_project.js

# baixa jquery para o projeto, caso tenha sido solicitado por parametro
if test "$tem_jquery" = 1
then
	curl -L -O https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js
fi

# copia arquivos pre-configurados
cd ..
mkdir example
cp $FILES_SETUP/.gitignore .gitignore
cp $FILES_SETUP/Makefile Makefile
cp -R $FILES_SETUP/test/ test

# renomeia arquivos de teste com o nome do projeto
cd test/
mv runner.html runner.$name_project.html
cd spec/
mv spec.js spec.$name_project.js

echo -e '\033[32mOk!\033[m'