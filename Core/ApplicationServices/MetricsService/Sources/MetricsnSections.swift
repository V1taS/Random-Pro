//
//  MetricsnSections.swift
//  MetricsService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public enum MetricsSections: String, MetricsSectionsProtocol {
  
  // Кнопка поделиться
  case shareApp = "Поделиться приложением (new version)"
  case shareImage = "Поделиться изображением (new version)"
  case shareColors = "Поделиться Цветом (new version)"
  case shareImageFilters = "Поделиться (Фильтр изображений) (new version)"
  
  // Категории
  case filmScreen = "Фильмы (new version)"
  case teamsScreen = "Команды (new version)"
  case numbersScreen = "Число (new version)"
  case yesOrNotScreen = "Да или нет (new version)"
  case charactersScreen = "Буква (new version)"
  case listScreen = "Список (new version)"
  case coinScreen = "Монета (new version)"
  case cubeScreen = "Кубики (new version)"
  case dateAndTimeScreen = "Дата и время (new version)"
  case lotteryScreen = "Лотерея (new version)"
  case contactScreen = "Контакт (new version)"
  case passwordScreen = "Пароли (new version)"
  case colorsScreen = "Цвета (new version)"
  case onboarding = "Onboarding (new version)"
  case bottleScreen = "Бутылочка (new version)"
  case rockPaperScissors = "Камень Ножницы Бумага (new version)"
  case imageFilters = "Фильтр изображений (new version)"
  
  // Настройки главного экрана
  case mainSettingsScreen = "Настройки главного экрана (new version)"
  case customMainSections = "Настройка секций на главном экране (new version)"
  case feedBack = "Обратная связь на почту (new version)"
  case selecteAppIcon = "Выбрать иконку для приложения"
  
  // Deep links
  
  case deepLinks = "DeepLinks"
  case premiumScreen = "Premium (new version)"
  
  case premiumPlayerCardSelection = "Premium player card selection"
}
