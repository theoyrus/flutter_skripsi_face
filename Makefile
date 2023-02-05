SHELL := /bin/bash
.POSIX:
.PHONY: help

## @egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
help: ## Show this help
	@grep -E '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

linux: ## Build Linux app
	flutter build linux

linux-release: ## Build Linux app [Release]
	flutter build linux --release

apk: ## Build APK
	flutter build apk

bundle: ## Build Android Bundle
	flutter build appbundle

apks-device: ## Build APK split for connected Device
	rm app.apks \
	&& bundletool build-apks --connected-device --bundle=build/app/outputs/bundle/release/app-release.aab --output=app.apks

install-apks: ## Install APK split for connected Device
	bundletool install-apks --apks=app.apks

release: ## Build Android Bundle [Release]
	flutter build appbundle --release

run: ## Run the devel app
	flutter run

initial: ## Install dependency
	flutter pub get

build_runner: ## Run build_runner
	flutter pub run build_runner build --delete-conflicting-outputs

env-read: ## Read Environment Vars
	@cat .env

env-setup: env-read build_runner ## Setup env vars untuk env.g.dart
	make env-read \
	&& env $(cat .env | xargs) \
	&& build_runner
