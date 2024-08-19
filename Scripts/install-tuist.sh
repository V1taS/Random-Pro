#!/bin/bash

# Определение системной директории для Tuist
TUIST_DIR="/usr/local/bin/tuist-installation"

# Проверка и установка zsh через Homebrew
echo "Checking if zsh is installed..."
if ! command -v zsh &> /dev/null; then
    echo "zsh not found, installing via Homebrew..."
    # Проверяем, установлен ли Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found, installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew installed successfully."
    else
        echo "Homebrew is already installed."
    fi
    # Устанавливаем zsh через Homebrew
    brew install zsh
    echo "zsh installed successfully."
else
    echo "zsh is already installed."
fi

# Скачивание Tuist 3.42.2 с GitHub
echo "Downloading Tuist 3.42.2..."
curl -L https://github.com/tuist/tuist/releases/download/3.42.2/tuist.zip --output tuist.zip

# Распаковка архива в системную директорию
echo "Unzipping Tuist..."
sudo mkdir -p $TUIST_DIR
sudo unzip tuist.zip -d $TUIST_DIR

# Удаление архива для освобождения места
echo "Cleaning up..."
rm tuist.zip

# Добавление Tuist в оболочку
SHELL_CONFIG=~/.zshrc
if [ ! -f "$SHELL_CONFIG" ]; then
    echo "Creating $SHELL_CONFIG because it does not exist."
    touch $SHELL_CONFIG
fi

echo "Adding Tuist to the $SHELL_CONFIG..."
echo "export PATH=\"$TUIST_DIR:\$PATH\"" >> $SHELL_CONFIG
echo "Tuist added to $SHELL_CONFIG successfully."
# Применение изменений без перезагрузки
source $SHELL_CONFIG

echo "Tuist installation completed successfully."
echo "Please restart your terminal or run 'source $SHELL_CONFIG' to use Tuist."
