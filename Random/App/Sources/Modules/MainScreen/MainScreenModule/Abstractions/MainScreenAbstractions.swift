//
//  MainScreenAbstractions.swift
//  Random
//
//  Created by Vitalii Sosin on 30.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainScreenModuleOutput: AnyObject {
  
  /// Главный экран был загружен
  func mainScreenModuleDidLoad()
  
  /// Главный экран был показан
  func mainScreenModuleDidAppear()
  
  /// Главный экран будет показан
  func mainScreenModuleWillAppear()
  
  /// Открыть раздел `Number`
  func openNumber()
  
  /// Открыть раздел `Teams`
  func openTeams()
  
  /// Открыть раздел `YesOrNo`
  func openYesOrNo()
  
  /// Открыть раздел `Character`
  func openCharacter()
  
  /// Открыть раздел `List`
  func openList()
  
  /// Открыть раздел `Coin`
  func openCoin()
  
  /// Открыть раздел `Cube`
  func openCube()
  
  /// Открыть раздел `DateAndTime`
  func openDateAndTime()
  
  /// Открыть раздел `Lottery`
  func openLottery()
  
  /// Открыть раздел `Contact`
  func openContact()
  
  /// Открыть раздел `Password`
  func openPassword()
  
  /// Открыть раздел `Colors`
  func openColors()
  
  /// Открыть раздел `Bottle`
  func openBottle()
  
  /// Открыть раздел `rockPaperScissors`
  func openRockPaperScissors()
  
  /// Открыть раздел `openImageFilters`
  func openImageFilters()
  
  /// Открыть раздел `Films`
  func openFilms()
  
  /// Открыть раздел `NickName`
  func openNickName()
  
  /// Открыть раздел `Joke`
  func openJoke()
  
  /// Открыть раздел `Slogans`
  func openSlogans()
  
  /// Открыть раздел `Names`
  func openNames()
  
  /// Открыть раздел `Добрые дела`
  func openGoodDeeds()
  
  /// Открыть раздел `Поздравления`
  func openCongratulations()
  
  /// Открыть раздел `Загадки`
  func openRiddles()
  
  /// Открыть раздел `Подарки`
  func openGifts()
  
  /// Открыть раздел `Колесо фортуны`
  func openFortuneWheel()
  
  /// Открыть раздел `Цитаты`
  func openQuotes()
  
  /// Открыть раздел `Правда или дело`
  func openTruthOrDare()
  
  /// Открыть раздел `Мемы`
  func openMemes()

  /// Открыть раздел `Сериалы`
  func openSeries()
  
  /// Была нажата кнопка (настройки)
  func settingButtonAction()
  
  /// Кнопка поделиться была нажата
  func shareButtonAction()
  
  /// Нет премиум доступа
  /// - Parameter section: Секция на главном экране
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section)
  
  /// Кнопка премиум была нажата
  /// - Parameter isPremium: Включен премиум
  func premiumButtonAction(_ isPremium: Bool)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainScreenModuleInput {
  
  /// Обновить секции главного экрана
  /// - Parameter models: Список секция
  func updateSectionsWith(models: [MainScreenModel.Section])
  
  /// Обновить секции на главном экране
  func updateStateForSections(with premium: Bool)
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool?)
  
  /// Сохранить премиум режим
  /// - Parameter isEnabled: Сохранить премиум режим
  func savePremium(_ isEnabled: Bool)
  
  /// Возвращает модель
  func returnModel(completion: @escaping (MainScreenModel) -> Void)
  
  /// Убрать лайбл с секции
  /// - Parameter type: Тип сеции
  func removeLabelFromSection(type: MainScreenModel.SectionType)
  
  /// Добавить лайбл к секции
  /// - Parameters:
  ///  - label: Лайбл
  ///  - for: Тип сеции
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
typealias MainScreenModule = ViewController & MainScreenModuleInput
