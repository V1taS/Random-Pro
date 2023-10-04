//
//  MetricsnSections.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// TODO: - Доработать название метрик

enum MetricsSections: String {
  
  // Кнопка поделиться
  case shareApp = "Поделиться приложением"
  case shareImage = "Поделиться изображением"
  case shareColors = "Поделиться Цветом"
  case shareImageFilters = "Поделиться (Фильтр изображений)"
  
  // Категории
  case filmScreen = "Фильмы"
  case teamsScreen = "Команды"
  case numbersScreen = "Число"
  case yesOrNotScreen = "Да или нет"
  case charactersScreen = "Буква"
  case listScreen = "Список"
  case coinScreen = "Монета"
  case cubeScreen = "Кубики"
  case dateAndTimeScreen = "Дата и время"
  case lotteryScreen = "Лотерея"
  case contactScreen = "Контакт"
  case passwordScreen = "Пароли"
  case colorsScreen = "Цвета"
  case bottleScreen = "Бутылочка"
  case rockPaperScissors = "Камень Ножницы Бумага"
  case imageFilters = "Фильтр изображений"
  case nickNameScreen = "Никнейм"
  case names = "Раздел имена"
  case congratulations = "Раздел поздравлений"
  case goodDeeds = "Раздел добрые дела"
  case riddles = "Раздел Загадки"
  case joke = "Раздел Анекдотов"
  case gifts = "Раздел Подарков"
  case slogans = "Раздел Слоганов"
  case quotes = "Раздел Цитат"
  case fortuneWheel = "Колесо фортуны"
  case truthOrDare = "Раздел Правда или действие"
  case memes = "Раздел Мемов"
  case onboarding = "Раздел Onboarding"
  
  // Настройки главного экрана
  case mainSettingsScreen = "Настройки главного экрана"
  case customMainSections = "Настройка секций на главном экране"
  case feedBack = "Обратная связь на почту"
  case selecteAppIcon = "Выбрать иконку для приложения"
  
  // Deep links
  
  case deepLinks = "DeepLinks"
  case premiumScreen = "Premium"
  case premiumWithFriends = "Premium with friends"
  
  case premiumPlayerCardSelection = "Premium player card selection"
  case premiumBottleStyleSelection = "Premium bottle style selection"
  case premiumCoinStyleSelection = "Premium coin style selection"
  
  // Other
  
  case forceUpdateApp = "Принудительное обновление показано"
  case appUnavailable = "Приложение не доступно"
}
