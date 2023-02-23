//
//  StorageService.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель главного экрана
  var mainScreenModel: MainScreenModelProtocol? { get set }
  
  /// Модель для чисел
  var numberScreenModel: NumberScreenModelProtocol? { get set }
  
  /// Модель для фильмов
  var filmsScreenModel: [FilmsScreenModelProtocol]? { get set }
  
  /// Модель для списка
  var listScreenModel: ListScreenModelProtocol? { get set }
  
  /// Модель для контактов
  var contactScreenModel: ContactScreenModelProtocol? { get set }
  
  /// Модель для кубиков
  var cubesScreenModel: CubesScreenModelProtocol? { get set }
  
  /// Модель для команд
  var teamsScreenModel: TeamsScreenModelProtocol? { get set }
  
  /// Модель для паролей
  var passwordScreenModel: PasswordScreenModelProtocol? { get set }
  
  /// Модель для лотереи
  var lotteryScreenModel: LotteryScreenModelProtocol? { get set }
  
  /// Модель для монетки
  var coinScreenModel: CoinScreenModelProtocol? { get set }
  
  /// Модель для буквы
  var letterScreenModel: LetterScreenModelProtocol? { get set }
  
  /// Модель для даты и времени
  var dateTimeScreenModel: DateTimeScreenModelProtocol? { get set }
  
  /// Модель для Да / Нет
  var yesNoScreenModel: YesNoScreenModelProtocol? { get set }
  
  /// Модель для выбора иконки
  var appIconScreenModel: SelecteAppIconScreenModelProtocol? { get set }
  
  /// Модель для выбора карточки игрока
  var playerCardSelectionScreenModel: [PlayerCardSelectionScreenModelProtocol]? { get set }
  
  /// Модель для глубоких ссылок
  var deepLinkModel: DeepLinkTypeProtocol? { get set }
}
