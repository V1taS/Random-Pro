//
//  FortuneWheelModel.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import UIKit

struct FortuneWheelModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String?
  
  /// Список результатов
  let listResult: [String]
  
  /// Стиль колеса удачи
  let style: Style
  
  /// Список секций
  let sections: [Section]
  
  /// Включение звука
  let isEnabledSound: Bool
  
  /// Включение обратной тактильной связи
  let isEnabledFeedback: Bool
  
  // MARK: - Section
  
  struct Section: UserDefaultsCodable {
    
    /// ID секции
    let id: String
    
    /// Секция выбрана
    let isSelected: Bool
    
    /// Низвание секции
    var title: String
    
    /// Смайлик секции
    var icon: String?
    
    /// Объекты
    var objects: [String]
    
    init(isSelected: Bool, title: String, icon: String?, objects: [String]) {
      self.isSelected = isSelected
      self.title = title
      self.icon = icon
      self.objects = objects
      id = UUID().uuidString
    }
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
