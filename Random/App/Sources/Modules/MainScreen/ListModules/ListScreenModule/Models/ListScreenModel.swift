//
//  ListScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Моделька
struct ListScreenModel: UserDefaultsCodable, Hashable {
  
  /// Без повторений
  let withoutRepetition: Bool
  
  /// Спсиок элементов для показа
  var allItems: [Section]
  
  /// Временное хранилище для уникальных элементов
  let tempUniqueItems: [TextModel]
  
  /// Спсиок сгенерированных элементов
  let generetionItems: [String]
  
  /// Результат генерации
  let result: String
  
  /// Моделька текста
  struct TextModel: UserDefaultsCodable, Hashable {
    
    /// ID текста
    let id: String
    
    /// Значение текста
    let text: String?
  }
  
  // MARK: - Section
  
  struct Section: UserDefaultsCodable, Hashable {
    
    /// ID секции
    let id: String
    
    /// Секция выбрана
    let isSelected: Bool
    
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
}
