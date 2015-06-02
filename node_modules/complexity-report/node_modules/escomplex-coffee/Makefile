COFFEE_FILES := $(wildcard src/*.coffee)
JS_FILES := $(addprefix lib/,$(notdir $(COFFEE_FILES:.coffee=.js)))

build: $(JS_FILES)

lib/%.js: src/%.coffee
	coffee -o lib -c src

watch:
	coffee --watch -o lib -c src
