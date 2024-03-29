#!/usr/bin/env bash

APP_NAME="schedule"
DMG_FILE_NAME="${APP_NAME}-Installer.dmg"
VOLUME_NAME="${APP_NAME} Installer"
SOURCE_FOLDER_PATH="${APP_NAME}.app"

# 构建dmg
cd build/macos/Build/Products/Release
# 下载create-dmg
git clone https://github.com/create-dmg/create-dmg.git
# 执行create-dmg
./create-dmg/create-dmg \
--volname "${VOLUME_NAME}" \
--window-pos 200 120 \
--window-size 800 400 \
--icon-size 100 \
--icon "${APP_NAME}.app" 200 190 \
--hide-extension "${APP_NAME}.app" \
--app-drop-link 600 185 \
"${DMG_FILE_NAME}" \
"${SOURCE_FOLDER_PATH}"