#!/bin/bash

# programa command line para startar projeto de novo componente javascript
# com os arquivos comumente usados
# author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
# https://github.com/evandrolg
# License: MIT

CONFIG="setup-js.conf"
FILES_SETUP=~/Projetos/pessoais/front-end/setup-lib-js/files
MENSAGEM_HELP="
\033[32mOPÇÕES:\033[m
-f, --filename: Dá nome ao arquivo da lib
-n, --name: Dá nome ao projeto
-d, --directory: Caminho do diretório onde projeto será criado
-j, --jquery: Baixa o script do jquery para o projeto
"

file_name=
name_project=
directory=
has_jquery=0

# faz parse dos arquivos de configuração
while read LINHA; do
   # remove todas as linhas com comentários
   [ "$(echo $LINHA | cut -c1)" = "#" ] && continue
   
   # remove todas as linhas em branco
   [ "$LINHA" ] || continue
   set - $LINHA
   chave=$1
   shift
   valor=$*

   case "$chave" in
      FILE_NAME)
         file_name=$valor
         ;;
   
      NAME_PROJECT)
         name_project=$valor
         ;;
   
      DIRECTORY)
         directory=$valor
         ;;
   
      HAS_JQUERY)
         [ "$valor" = "YES" ] && has_jquery=1
         ;;
   
      *)
         echo "O arquivo de configuração está corrompido"
         exit 1
   esac
done < "$CONFIG"

# varre todos os parametros passados na execução do programa
while test -n "$1"
do
 case "$1" in
    -h | --help )
         echo -e "$MENSAGEM_HELP"
         exit 0
      ;;

      -f | --file_name )
       shift
       file_name="$1"
    ;;

      -n | --name_project )
         shift
         name_project="$1"
      ;;

      -d | --directory )
         shift
         directory="$1"
      ;;

    -j | --jquery )
       has_jquery=1
    ;;
 esac
 shift
done

directory=~/Projetos/pessoais/front-end

# cria diretorio com o nome do projeto
cd $directory
mkdir $file_name
NEW_PROJECT=$directory/$file_name

# # copia arquivos pre-configurados
cd $file_name/
cp $FILES_SETUP/.gitignore .gitignore
cp $FILES_SETUP/Makefile Makefile
cp -R $FILES_SETUP/test/ test
mkdir example
cp $FILES_SETUP/example.html example/example.html

# # baixa lib jasmine, descompacta e remove
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
mv runner.html runner.$file_name.html
cd spec/
mv spec.js spec.$file_name.js

# cria arquivo de source principal com o nome do projeto
cd $NEW_PROJECT
mkdir src
cd src/
touch $file_name.js

# baixa jquery para o projeto, caso tenha sido solicitado por parametro
if test "$tem_jquery" = 1
then
   curl -L -O https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js
   echo ""
fi

# modifica nome de valores - nome do projeto e nome do arquivo - de acordo
# com o que foi passado por parametro
cd ..
sed -i.bak "s/{{ NAME_FILE }}/$file_name/" test/runner.$file_name.html example/example.html
rm -rf test/runner.$filename.html.bak example/example.html.bak
sed -i.bak "s/{{ NAME_PROJECT }}/$name_project/" test/runner.$file_name.html example/example.html test/spec/spec.$file_name.js
rm -rf test/runner.$file_name.html.bak example/example.html.bak test/spec/spec.$file_name.js.bak

echo -e "\033[32mOk!\033[m"