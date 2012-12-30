install:
	@cp -rf "$(CURDIR)" /usr/local/lib/setup-js/
	@ln -s /usr/local/lib/setup-js/setup-js.sh /usr/local/bin/setup-js