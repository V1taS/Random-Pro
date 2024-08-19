#!/bin/sh
# Срабатывает после СБОРКИ проекта

# Генерация версий
MARKETING_VERSION="778.$CI_BUILD_NUMBER"
CURRENT_PROJECT_VERSION="$CI_BUILD_NUMBER"

# Переход в папку с проектом
cd /Volumes/workspace/repository/

# Определение текущей ветки из переменной окружения Xcode Cloud
current_branch=$CI_COMMIT_BRANCH

# Проверка, что не происходит Pull Request
if [ -z "$CI_PULL_REQUEST_NUMBER" ] && [ -z "$CI_PULL_REQUEST_SOURCE_BRANCH" ]; then
    # Установка токена для GitHub Actions
    git config --global user.email "github-actions[bot]@users.noreply.github.com"
    git config --global user.name "GitHub Actions Bot"
    
    # Создание и пуш git тега
    git tag $MARKETING_VERSION
    
    # Установка токена аутентификации для GitHub
    git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/V1taS/Random-Pro.git
    
    # Пуш тегов
    git push --tags

    # Отправка уведомления в Telegram для мастер ветки
    python3 /Volumes/workspace/repository/Scripts/send_telegram.py "🎰🎰🎰 Релиз Random-Pro iOS $MARKETING_VERSION 🎰🎰🎰
Сборка №: $CI_BUILD_NUMBER
URL сборки: $CI_BUILD_URL
Продукт: $CI_PRODUCT
Версия: $MARKETING_VERSION/$CURRENT_PROJECT_VERSION
Проект: https://github.com/V1taS/Random-Pro

Для тестирования релизных сборок отправьте свой Apple ID (example@iCloud.com) пользователю @V1taS
"
else
    # Отправка уведомления в Telegram для не мастер веток
    python3 /Volumes/workspace/repository/Scripts/send_telegram.py "🎰 Новый Pull Request для Random-Pro! 🎰
Сборка №: $CI_BUILD_NUMBER
URL сборки: $CI_BUILD_URL
Продукт: $CI_PRODUCT
Проект: https://github.com/V1taS/Random-Pro
PR ссылка: $CI_PULL_REQUEST_HTML_URL
Номер PR: $CI_PULL_REQUEST_NUMBER
Исходная ветка PR: $CI_PULL_REQUEST_SOURCE_BRANCH
Целевая ветка PR: $CI_PULL_REQUEST_TARGET_BRANCH

Для тестирования релизных сборок отправьте свой Apple ID (example@iCloud.com) пользователю @V1taS
"
fi
