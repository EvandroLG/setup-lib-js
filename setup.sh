#!/bin/bash

# programa command line para startar projeto de novo componente javascript
# com os arquivos comumente usados
# author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
# https://github.com/evandrolg
# License: MIT

HAS_JQUERY=0
FILE_NAME=
NAME=
DIRECTORY=

CONFIG="setup-js.conf"
PROJECTS=~/Projetos/pessoais/front-end
FILES_SETUP=$PROJECTS/setup-lib-js/files
MENSAGEM_HELP="
\033[32mOPÇÕES:\033[m
-f, --filename: Dá nome ao arquivo da lib
-n, --name: Dá nome ao projeto
-d, --directory: Caminho do diretório onde projeto será criado
-j, --jquery: Baixa o script do jquery para o projeto
"

while read LINHA; do
   [ "$(echo $LINHA | cut -c1)" = "#" ] && continue
   [ "$LINHA" ] || continue
   set - $LINHA
   chave=$1
   shift
   valor=$*
   echo "$chave -> $valor"   
done < "$CONFIG"


varre todos os parametros passados na execução do programa
while test -n "$1"
do
 case "$1" in
    -h | --help )
         echo -e "$MENSAGEM_HELP"
         exit 0
      ;;

      -f | --file_name ) # guarda o valor do nome do arquivo passado por parametro
       shift
       file_name="$1"
    ;;

      -n | --name ) # guarda o valor do nome do projeto passado por parametro
         shift
         name_project="$1"
      ;;

      -d | --directory ) # guarda o valor com o diretorio onde será criado o programa
         shift
         directory="$1"
      ;;

    -j | --jquery ) # guarda flag identificando a necessidade de carregar jquery
       tem_jquery=1
    ;;
 esac
 shift
done

# cria diretorio com o nome do projeto
cd $PROJECTS
mkdir $filename
NEW_PROJECT=$PROJECTS/$filename

# copia arquivos pre-configurados
cd $filename/
cp $FILES_SETUP/.gitignore .gitignore
cp $FILES_SETUP/Makefile Makefile
cp -R $FILES_SETUP/test/ test
mkdir example
cp $FILES_SETUP/example.html example/example.html

# baixa lib jasmine, descompacta e remove
cd test
curl -L -O https://github.com/downloads/pivotal/jasmine/jasmine-standalone-1.3.1.zip
echo ""
unzip jasmine-standalone-1.3.1.zip -d jasmine/
echo ""
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
mv runner.html runner.$filename.html
cd spec/
mv spec.js spec.$filename.js

# cria arquivo de source principal com o nome do projeto
cd $NEW_PROJECT
mkdir src
cd src/
touch $filename.js

# baixa jquery para o projeto, caso tenha sido solicitado por parametro
if test "$tem_jquery" = 1
then
 curl -L -O https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js
 echo ""
fi

# modifica nome de valores - nome do projeto e nome do arquivo - de acordo
# com o que foi passado por parametro
cd ..
sed -i.bak "s/{{ NAME_FILE }}/$filename/" test/runner.$filename.html example/example.html
rm -rf test/runner.$filename.html.bak example/example.html.bak
sed -i.bak "s/{{ NAME_PROJECT }}/$name_project/" test/runner.$filename.html example/example.html test/spec/spec.$filename.js
rm -rf test/runner.$filename.html.bak example/example.html.bak test/spec/spec.$filename.js.bak

echo -e "\033[32mOk!\033[m"