#!/bin/sh
# Этот скрипт предназначен для использования после клонирования репозитория GIT и перед разрешением зависимостей

# ----------------------- 1️⃣ Установка Python и зависимостей -----------------------

python3 -m pip install --upgrade pip
pip3 install python-telegram-bot

# ----------------------- 2️⃣ Установка Tuist -----------------------

# Скачивает архив Tuist 3.42.2 с GitHub
curl -L https://github.com/tuist/tuist/releases/download/3.42.2/tuist.zip --output tuist.zip
# Распаковывает скачанный архив в директорию tuist-installation
unzip tuist.zip -d tuist-installation
# Удаляет архив, чтобы освободить место
rm tuist.zip

# ----------------------- 3️⃣ Настройка Tuist -----------------------

# Добавляет папку с Tuist в переменную окружения PATH, чтобы можно было вызвать Tuist из любого места
export PATH="$PWD/tuist-installation:$PATH"

# ----------------------- 4️⃣ Подготовка в запуску Tuist generate -----------------------

# Удаляет настройку Xcode, принуждающую использовать только версии пакетов из файла Resolved
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile

# Удаляет настройку Xcode, отключающую автоматическое разрешение зависимостей
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

# Отключает валидацию отпечатков макросов Xcode для ускорения процесса сборки
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 5️⃣ Запуск Tuist -----------------------

# Переход в папку с проектом
cd /Volumes/workspace/repository/

# Запускаем Tuist
tuist clean && tuist fetch && tuist generate --no-open
