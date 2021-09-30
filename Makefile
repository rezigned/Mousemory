NAME   = Mousemory
KEY    = $(shell echo $(NAME) | tr 'A-Z' 'a-z')
APP    = $(NAME).app
DMG    = $(NAME).dmg
BUNDLE = com.rezigned.$(NAME)
ICON   = .github/icon.icns
BUILD_DIR = ./build/Release

# github
GITHUB_URL  = https://github.com/rezigned/$(NAME)
RELEASE_URL = $(GITHUB_URL)/releases/download/v\#\{version\}/$(DMG)

# homebrew
CASK_DIR  = $(shell brew --repository)/Library/Taps/homebrew/homebrew-cask
CASK_FILE = $(CASK_DIR)/Casks/mousemory.rb
BREW   	  = brew
DESC      = $(NAME) - remembers mouse position across multiple monitors

.PHONY: install build

install: check
	create-dmg \
	--volname $(NAME) \
	--window-pos 200 120 \
	--window-size 800 400 \
	--hide-extension "$(APP)" \
	--app-drop-link 600 185 \
	--volicon "$(ICON)" \
	--icon-size 128 \
	--icon "$(APP)" 200 190 \
	"$(DMG)" \
	$(BUILD_DIR)

check:
	[ -f "$(DMG)" ] && rm $(DMG) || true
	[ -d "$(BUILD_DIR)/$(APP).dSYM" ] && rm -rf $(BUILD_DIR)/*.dSYM || true
	[ -d "$(BUILD_DIR)/$(NAME).swiftmodule" ] && rm -rf $(BUILD_DIR)/*.swiftmodule || true

clean:
	defaults delete $(BUNDLE)

build:
	xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO

version:
	plutil -p $(NAME)/Info.plist | grep CFBundleShortVersionString | awk '{ print $$3 }'

cask-token:
	$(CASK_DIR)/developer/bin/generate_cask_token $(APP) 2>/dev/null \
	| grep "Proposed token" \
	| awk '{ print $$3 }'

cask-create:
	brew create --cask $(RELEASE_URL) --set-name "$(shell $(MAKE) -s cask-token)"

cask-edit:
	cat $(CASK_FILE)

cask-audit:
	brew audit --new-cask $(KEY)

cask-style:
	brew style --fix $(KEY)

cask-checksum: $(DMG)
	shasum -a 256 $(DMG) | awk '{print $$1}'

cask-update:
	sed -i -E -e 's/\(url[ ]*\)"[^"]*"/\1"$(shell echo $(GITHUB_URL) | sed 's/\//\\\//g')"/g' \
	-e 's/\(app[ ]*\)"[^"]*"/\1"$(APP)"/g' \
	-e 's/\(name[ ]*\)"[^"]*"/\1"$(NAME)"/g' \
	-e 's/\(desc[ ]*\)"[^"]*"/\1"$(DESC)"/g' \
	-e 's/\(url[ ]*\)"[^"]*"/\1"$(shell echo $(RELEASE_URL) | sed 's/\//\\\//g')"/g' \
	-e 's/\(homepage[ ]*\)"[^"]*"/\1"$(shell echo $(GITHUB_URL) | sed 's/\//\\\//g')"/g' \
	-e 's/\(version[ ]*\)"[^"]*"/\1"$(shell $(MAKE) -s version | sed 's/"//g')"/g' \
	-e 's/\(sha256[ ]*\)make "[^"]*"/\1"$(shell $(MAKE) -s cask-checksum)"/g' $(CASK_FILE)
