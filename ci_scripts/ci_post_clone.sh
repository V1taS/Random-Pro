#!/bin/sh

# Этот скрипт предназначен для Xcode Cloud (или любой другой CI-системы),
# где может не быть ни Tuist, ни mise.
# Запускается после клонирования репозитория и перед сборкой.

set -e  # Прерываем выполнение скрипта при любой ошибке

# ----------------------- 1️⃣ Установка/обновление Python и зависимостей -----------------------
echo "Обновляем pip и устанавливаем зависимости..."
python3 -m pip install --upgrade pip
pip3 install --upgrade python-telegram-bot

# ----------------------- 2️⃣ Установка Homebrew (если не установлен) -----------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew не найден. Устанавливаем Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Обновляем Homebrew..."
brew update

# ----------------------- 3️⃣ Установка mise через Homebrew -----------------------
echo "Устанавливаем mise..."
brew install mise

# ----------------------- 4️⃣ Подготовка Xcode -----------------------
echo "Обновляем настройки Xcode для ускорения сборки..."
# Удаляет настройку Xcode, принуждающую использовать только версии пакетов из файла Resolved
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile

# Удаляет настройку Xcode, отключающую автоматическое разрешение зависимостей
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

# Отключает валидацию отпечатков макросов Xcode для ускорения процесса сборки
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 5️⃣ Подготовка Tuist -----------------------
echo "Устанавливаем Tuist через mise..."
mise install tuist

# Поиск установленного Tuist
echo "Ищем установленный Tuist..."
TUIST_PATH=$(find $HOME/.local -type f -name "tuist" | head -n 1)

if [ -z "$TUIST_PATH" ]; then
    echo "Ошибка: Tuist не найден после установки."
    exit 1
fi

echo "Tuist найден по пути: $TUIST_PATH"

# ----------------------- 6️⃣ Подготовка проекта -----------------------
# Переход в папку с проектом
echo "Переходим в директорию с проектом..."
cd /Volumes/workspace/repository/

# Выполняем команды Tuist
echo "Очищаем проект с помощью Tuist..."
"$TUIST_PATH" clean

echo "Устанавливаем зависимости проекта с помощью Tuist..."
"$TUIST_PATH" install

echo "Генерируем проект с помощью Tuist..."
"$TUIST_PATH" generate --no-open

echo "Скрипт завершён успешно!"
