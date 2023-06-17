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
  
  /// Выбранная секция
  let selectedSection: Section
  
  /// Включение звука
  let isEnabledSound: Bool
  
  /// Включение обратной тактильной связи
  let isEnabledFeedback: Bool
  
  /// Включение списка результатов на главном экране
  let isEnabledListResult: Bool
  
  // MARK: - Section
  
  struct Section: UserDefaultsCodable {
    
    /// Низвание секции
    let title: String
    
    /// Смайлик секции
    let icon: String?
    
    /// Объекты
    let objects: [String]
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
