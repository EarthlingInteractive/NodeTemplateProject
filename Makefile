src = $(shell find src -name '*.js')
lib = $(src:src/%.js=lib/%.js)
webserver_port ?= 4000

default: lib

.PHONY: \
	clean \
	default \
	run-server

clean:
	rm -rf node_modules lib

node_modules: package.json
	npm install
	touch "$@"

lib: $(lib)
	touch "$@"

# 'babel -b flow' if we wanted to pass it all through flow as a second step
lib/%.js: src/%.js node_modules
	mkdir -p $(@D)
	node_modules/babel/bin/babel.js --stage=0 $< -o $@

run-server: lib
	node lib/main/run-server.js -port ${webserver_port}

run-unit-tests: lib node_modules
	node_modules/nodeunit/bin/nodeunit lib/test
