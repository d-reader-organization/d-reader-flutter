include .env
# Makefile for building Flutter APK
# Assumes that the Flutter SDK is installed and on your PATH

# # Set the name of your Flutter project
# PROJECT_NAME=dReader

# # Set the name of your Android module (if different from the project name)
# ANDROID_MODULE_NAME=my_flutter_app_module

# # Set the build type (debug or release)
# BUILD_TYPE=release

# # Set the flavor (if applicable)
# FLAVOR=prod

# # Set the path to your Flutter SDK
# FLUTTER_SDK_PATH=/path/to/flutter/sdk

# # Set the path to your Android SDK
# ANDROID_SDK_PATH=/path/to/android/sdk

# # Set the path to your Android NDK
# ANDROID_NDK_PATH=/path/to/android/ndk
API_URL_DEV="https://api-dev-mainnet.dreader.io"
API_URL_DEV_DEVNET="https://api-dev-devnet.dreader.io"
API_URL_PROD="https://api-main-mainnet.dreader.io"
API_URL_PROD_DEVNET="https://api-main-devnet.dreader.io"

all: build-dev build-prod build-prod-apk

build-dev:
	flutter clean && \
	flutter build apk --split-per-abi --release --dart-define=apiUrl=$(API_URL_DEV) --dart-define=apiUrlDevnet=$(API_URL_DEV_DEVNET) --dart-define=sentryDsn=${sentryDsn} --flavor dev --target lib/main_dev.dart && \
	mv ./build/app/outputs/flutter-apk/app-armeabi-v7a-dev-release.apk ./apks/dReader-dev.apk

build-prod:
	flutter clean && \
	flutter build appbundle --release --dart-define=apiUrl=$(API_URL_PROD) --dart-define=apiUrlDevnet=$(API_URL_PROD_DEVNET) --dart-define=sentryDsn=${sentryDsn} --flavor prod --target lib/main_prod.dart && \
	mv ./build/app/outputs/bundle/prodRelease/app-prod-release.aab ./apks/dReader.aab

build-prod-apk:
	flutter clean && \
	flutter build apk --split-per-abi --release --dart-define=apiUrl=$(API_URL_PROD) --dart-define=apiUrlDevnet=$(API_URL_PROD_DEVNET) --dart-define=sentryDsn=${sentryDsn} --flavor prod --target lib/main_prod.dart && \
	mv ./build/app/outputs/flutter-apk/app-armeabi-v7a-prod-release.apk ./apks/dReader.apk

start-saga-release:
	pre-saga-release create-saga-release publish-saga-update

pre-saga-release:
	make build-prod-apk && mv ./apks/dReader.apk ./publishing/

create-saga-release:
	cd publishing && NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && nvm use && npx dapp-store create release -k ${keyPairPath} -b ~/Library/Android/sdk/build-tools/34.0.0-rc3 -u ${rpcMainnet}

publish-saga-update:
	cd publishing && NVM_DIR="$${HOME}/.nvm" && . "$${NVM_DIR}/nvm.sh" && nvm use && npx dapp-store publish update -k ${keyPairPath} -u ${rpcMainnet} --requestor-is-authorized --complies-with-solana-dapp-store-policies

clean:
	flutter clean

.PHONY: all clean