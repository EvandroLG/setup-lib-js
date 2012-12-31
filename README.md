# setup-lib
setup-lib is a command line tool to create a new project in JavaScript, with all essential: lib to test, 
jshint, minify tool, directory example.

## Instalation
```
git clone https://github.com/EvandroLG/setup-lib-js.git
cd setup-lib-js/
make
```

## How to use
After installed, to create a new project JS run the following command:
```
setup-js -f my-project-js -n MyProjectJS -d MyProjects/js/ -j
```
If all goes well, the project will be created in the following structure:
- my-project-js
	- Makefile
	- .gitignore
	- src/
		- my-project-js.js
		- jquery.js
  - test/
    - jasmine/
			- css/
					jasmine.css
			- js/
					jasmine.js
					jasmine-html.js
    - spec/
			spec.my-project-js
    - runner.my-project-js
  - example/
    - example.html

## Options
Supported options:
*  <code>-f</code> or <code>--file_name</code>
*  <code>-n</code> or <code>--name_project</code>
*  <code>-d</code> or <code>--directory</code>
*  <code>-j</code> or <code>--jquery</code>

## Configuration