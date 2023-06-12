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
  let result: Object?
  
  /// Список результатов
  let listResult: [Object]
  
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
  
  // MARK: - Section
  
  struct Section: UserDefaultsCodable {
    
    /// Низвание секции
    let title: String
    
    /// Иконка секции
    let icon: Data?
    
    /// Объекты
    let objects: [Object]
  }
  
  // MARK: - Object
  
  struct Object: UserDefaultsCodable {
    
    /// Заголовок
    let title: String
    
    /// Описание
    let description: String?
    
    /// Изображение
    let image: Data?
  }
  
  // MARK: - Style
  
  enum Style: CaseIterable, UserDefaultsCodable {
    
    /// Обычный
    case regular
  }
}
