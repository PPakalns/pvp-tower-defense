
LOVE_NAME = TemplateGame
LOVE_SRC = ./src
LOVE_RELEASE = ./release

LOVE_LOVE = "$(LOVE_NAME).love"

.PHONY: clean build release all

all: build

build: $(LOVE_LOVE)

$(LOVE_LOVE): $(shell find $(LOVE_SRC) -type f)
	(cd $(LOVE_SRC) && zip -9 -r "../$(LOVE_LOVE)" .)

run: $(LOVE_LOVE)
	love $(LOVE_SRC)

clean:
	rm -f $(LOVE_RELEASE)
	rm -f $(LOVE_LOVE)

release: $(shell find $(LOVE_SRC) -type f)
	love-release -D -M -W 32 -W 64 $(LOVE_RELEASE) $(LOVE_SRC)

web-release: love.js
	cd love.js/debug; \
		python ../emscripten/tools/file_packager.py game.data --preload ../../$(LOVE_SRC)@/ --js-output=game.js

web-run: web-release
	cd love.js/debug; \
		python -m SimpleHTTPServer 8900

love.js:
	git clone https://github.com/TannerRogalsky/love.js.git
	(cd love.js && git submodule update --init --recursive)

