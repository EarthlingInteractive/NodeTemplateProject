src = $(shell find src -name '*.js')
lib = $(src:src/%.js=lib/%.js)
webserver_port ?= 4000

default: lib

.DELETE_ON_ERROR: # Yes, please!

.PHONY: \
	clean \
	create-database \
	drop-database \
	upgrade-database \
	default \
	run-server

clean:
	rm -rf node_modules lib vendor

# Dependency management stuff

node_modules: package.json
	npm install
	touch "$@"

vendor: composer.lock
	composer install
	touch "$@"

composer.lock: composer.json
	rm -f composer.lock
	composer install

# Compile JS stuff

lib: $(lib)
	touch "$@"

# 'babel -b flow' if we wanted to pass it all through flow as a second step
lib/%.js: src/%.js node_modules
	mkdir -p $(@D)
	node_modules/babel/bin/babel.js --stage=0 $< -o $@

# Run server stuff

run-server: lib
	node lib/main/run-server.js -port ${webserver_port}

# Database stuff

util/nodetemplateprojectdatabase-psql: config/dbc.json vendor
	mkdir -p util
	vendor/bin/generate-psql-script -psql-exe psql "$<" >"$@"
	chmod +x "$@"
util/nodetemplateprojectdatabase-pg_dump: config/dbc.json vendor
	mkdir -p util
	vendor/bin/generate-psql-script -psql-exe pg_dump "$<" >"$@"
	chmod +x "$@"

build/db/create-database.sql: config/dbc.json vendor
	vendor/bin/generate-create-database-sql "$<" >"$@"
build/db/drop-database.sql: config/dbc.json vendor
	vendor/bin/generate-drop-database-sql "$<" >"$@"

create-database drop-database: %: build/db/%.sql
	sudo su postgres -c "cat '$<' | psql"

upgrade-database: vendor config/dbc.json
	vendor/bin/upgrade-database -upgrade-table 'nodetemplateprojectdatabasenamespace.schemaupgrade'
empty-database: build/db/empty-database.sql util/nodetemplateprojectdatabase-psql
	cat "$<" | util/nodetemplateprojectdatabase-psql -v ON_ERROR_STOP=1

# Test stuff

run-unit-tests: lib node_modules upgrade-database
	node_modules/nodeunit/bin/nodeunit lib/test
