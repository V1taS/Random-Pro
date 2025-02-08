//
//  FortuneWheelModel.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import UIKit
import SKAbstractions

struct FortuneWheelModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String?
  
  /// Список результатов
  let listResult: [String]
  
  /// Стиль колеса удачи
  let style: Style
  
  /// Список секций
  var sections: [Section]
  
  /// Включение обратной тактильной связи
  let isEnabledFeedback: Bool
  
  // MARK: - Section
  
  struct Section: UserDefaultsCodable {
    
    /// ID секции
    let id: String
    
    /// Секция выбрана
    var isSelected: Bool
    
    /// Низвание секции
    var title: String
    
    /// Смайлик секции
    var icon: String?
    
    /// Объекты
    var objects: [TextModel]
    
    init(isSelected: Bool, title: String, icon: String?, objects: [TextModel]) {
      self.isSelected = isSelected
      self.title = title
      self.icon = icon
      self.objects = objects
      id = UUID().uuidString
    }
  }
  
  /// Моделька текста
  struct TextModel: UserDefaultsCodable, Hashable {
    
    /// ID текста
    let id: String
    
    /// Значение текста
    let text: String?
  }
  
  // MARK: - Style
  
  enum Style: CaseIterable, UserDefaultsCodable {
    
    /// Обычный
    case regular
  }
  
  // MARK: - MockSection
  
  enum MockSection: CaseIterable, UserDefaultsCodable {
    
    /// Правда или действие
    case truthOrDare
    
    /// Да или нет
    case yesOrNo
    
    /// Какой цвет
    case whatColor
  }
}
