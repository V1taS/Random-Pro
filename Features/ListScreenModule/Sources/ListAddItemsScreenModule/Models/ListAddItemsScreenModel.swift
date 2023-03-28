//
//  ListAddItemsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

// MARK: - ListAddItemsScreenModel

/// Моделька для таблички
enum ListAddItemsScreenModel: Codable, Equatable {
  
  /// Секция Текста
  /// - Parameter textModel: Моделька для текста
  case text(ListScreenModel.TextModel)
  
  /// Секция отступа
  case insets(Double)
  
  /// Секция текстового поля
  case textField
  
  /// Разделитель
  case divider
  
  /// Двойной заголовок
  /// - Parameters:
  ///  - textCount: Всего текста
  ///  - textForGeneratedCount: Все текста, для генерации
  case doubleTitle(textCount: Int, textForGeneratedCount: Int?)
}
