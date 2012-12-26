#!/bin/bash
# ferramenta command line para startar projeto de novo componente javascript, com os arquivos comumente usados
# author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
# https://github.com/evandrolg
# License: MIT

# varre todos os parametros passados na execução do programa
while test -n "$1"
do
	case "$1" in
      -n | --name ) # guarda valor de nome passado por parametro
			shift
			name_project="$1"
		;;

		-j | --jquery ) # guarda flag identificando a necessidade de carregar jquery
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

# copia arquivos pre-configurados
cd $name_project/
cp $FILES_SETUP/.gitignore .gitignore
cp $FILES_SETUP/Makefile Makefile
cp -R $FILES_SETUP/test/ test

# baixa lib jasmine, descompacta e remove
cd test
curl -L -O https://github.com/downloads/pivotal/jasmine/jasmine-standalone-1.3.1.zip
unzip jasmine-standalone-1.3.1.zip -d jasmine/
rm -rf jasmine-standalone-1.3.1.zip

# migra arquivos do jasmine para os diretorios corretos
cd jasmine
mkdir js
mkdir css

mv lib/jasmine-1.3.1/jasmine-html.js js/jasmine-html.js
mv lib/jasmine-1.3.1/jasmine.js js/jasmine.js
mv lib/jasmine-1.3.1/jasmine.css css/jasmine.css

# remove arquivos e diretórios desnecessarios do jasmine
rm -rf lib jasmine-standalone-1.3.1.zip SpecRunner.html src spec

# renomeia arquivos de teste com o nome do projeto
cd ..
mv runner.html runner.$name_project.html
cd spec/
mv spec.js spec.$name_project.js

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

echo -e "\033[32mOk!\033[m"