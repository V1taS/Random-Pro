//
//  ListScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - ListScreenModel

/// Моделька
public struct ListScreenModel: Codable {
  
  /// Без повторений
  public let withoutRepetition: Bool
  
  /// Спсиок элементов для показа
  public let allItems: [TextModel]
  
  /// Временное хранилище для уникальных элементов
  public let tempUniqueItems: [TextModel]
  
  /// Спсиок сгенерированных элементов
  public let generetionItems: [String]
  
  /// Результат генерации
  public let result: String
  
  // MARK: - TextModel
  
  /// Моделька текста
  public struct TextModel: Codable, Hashable {
    
    /// ID текста
    public let id: String
    
    /// Значение текста
    public let text: String?
  }
}
