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
struct ListScreenModel: Codable, ListScreenModelProtocol {
  
  /// Без повторений
  let withoutRepetition: Bool
  
  /// Спсиок элементов для показа
  let allItems: [ListScreenTextModelProtocol]
  
  /// Временное хранилище для уникальных элементов
  let tempUniqueItems: [ListScreenTextModelProtocol]
  
  /// Спсиок сгенерированных элементов
  let generetionItems: [String]
  
  /// Результат генерации
  let result: String
  
  // MARK: - Initialization
  
  init(withoutRepetition: Bool,
       allItems: [TextModel],
       tempUniqueItems: [TextModel],
       generetionItems: [String],
       result: String) {
    self.withoutRepetition = withoutRepetition
    self.allItems = allItems
    self.tempUniqueItems = tempUniqueItems
    self.generetionItems = generetionItems
    self.result = result
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    withoutRepetition = try container.decode(Bool.self, forKey: .withoutRepetition)
    allItems = try container.decode([TextModel].self, forKey: .allItems)
    tempUniqueItems = try container.decode([TextModel].self, forKey: .tempUniqueItems)
    generetionItems = try container.decode([String].self, forKey: .generetionItems)
    result = try container.decode(String.self, forKey: .result)
  }
  
  // MARK: - Func `Encode`
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(withoutRepetition, forKey: .withoutRepetition)
    try container.encode(allItems as? [TextModel], forKey: .allItems)
    try container.encode(tempUniqueItems as? [TextModel], forKey: .tempUniqueItems)
    try container.encode(generetionItems, forKey: .generetionItems)
    try container.encode(result, forKey: .result)
  }
  
  // MARK: - TextModel
  
  enum CodingKeys: CodingKey {
    case withoutRepetition
    case allItems
    case tempUniqueItems
    case generetionItems
    case result
  }
  
  // MARK: - TextModel
  
  /// Моделька текста
  struct TextModel: Codable, Hashable, ListScreenTextModelProtocol {
    
    /// ID текста
    let id: String
    
    /// Значение текста
    let text: String?
  }
}

// MARK: - toCodable

extension ListScreenModelProtocol {
  func toCodable() -> ListScreenModel {
    let newAllItems: [ListScreenModel.TextModel] = allItems.map {
      return ListScreenModel.TextModel(id: $0.id, text: $0.text)
    }

    let newTempUniqueItems: [ListScreenModel.TextModel] = tempUniqueItems.map {
      return ListScreenModel.TextModel(id: $0.id, text: $0.text)
    }

    return ListScreenModel(withoutRepetition: withoutRepetition,
                           allItems: newAllItems,
                           tempUniqueItems: newTempUniqueItems,
                           generetionItems: generetionItems,
                           result: result)
  }
}
