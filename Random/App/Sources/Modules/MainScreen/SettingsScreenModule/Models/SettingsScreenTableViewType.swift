//
//  SettingsScreenTableViewType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 21.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - SettingsScreenTableViewType

/// Моделька для таблички
enum SettingsScreenTableViewType {
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - listOfItems: Список элементов
  ///  - startSelectedSegmentIndex: Выбранный элемент
  ///  - valueChanged: Действие на изменение языка
  case labelWithSegmentedControl(title: String,
                                 listOfItems: [String],
                                 startSelectedSegmentIndex: Int,
                                 valueChanged: ((_ index: Int) -> Void)?
  )
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - isEnabled: Переключатель
  case titleAndSwitcher(title: String, isEnabled: Bool)
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - isEnabled: Результат
  case titleAndSwitcherAction(title: String,
                              (isEnabled: Bool, completion: ((_ isEnabled: Bool) -> Void)?))
  
  /// Секция `Заголовок и описание`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - description: Описание
  case titleAndDescription(title: String, description: String)
  
  /// Секция `Заголовок и иконка сбоку`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - id: ID Секции
  case titleAndChevron(title: String, id: IdAction = .listOfObjects)
  
  /// Кнопка очистеть
  /// - Parameter title: Название кнопки
  case cleanButtonModel(title: String?)
  
  /// Секция отступа
  case insets(Double)
  
  /// Разделитель
  case divider
  
  /// Ид экшена
  enum IdAction {
    
    /// Список объектов
    case listOfObjects
    
    /// Создать список
    case createList
    
    /// Пользователь выбрал изменить карточку игрока в секции "Команды"
    case playerCardSelection

    /// Пользователь выбрал изменить стиль бутылочки в секции "Бутылочка"
    case bottleStyleSelection
  }
}
