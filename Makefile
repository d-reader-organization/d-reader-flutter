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
DEFINE_API_URL_DEV="--dart-define=apiUrl=https://d-reader-backend-dev.herokuapp.com"
DEFINE_API_URL_DEV_DEVNET="--dart-define=apiUrl=https://d-reader-backend-dev-devnet.herokuapp.com"
DEFINE_API_URL_PROD="--dart-define=apiUrl=https://d-reader-backend.herokuapp.com"
DEFINE_API_URL_PROD_DEVNET="--dart-define=apiUrl=https://d-reader-backend-devnet.herokuapp.com"

all: build-dev build-prod

build-dev:
	flutter clean && \
	flutter build apk --split-per-abi --release --dart-define=apiUrl=https://d-reader-backend-dev.herokuapp.com --dart-define=apiUrlDevnet=https://d-reader-backend-dev-devnet.herokuapp.com --flavor dev && \
	mv ./build/app/outputs/flutter-apk/app-armeabi-v7a-dev-release.apk ./apks/dReader-dev.apk

build-prod:
	flutter clean && \
	flutter build appbundle --release --dart-define=apiUrl=https://d-reader-backend.herokuapp.com --dart-define=apiUrlDevnet=https://d-reader-backend-devnet.herokuapp.com --flavor prod && \
	mv ./build/app/outputs/bundle/prodRelease/app-prod-release.aab ./apks/dReader.aab

clean:
	flutter clean

.PHONY: all clean