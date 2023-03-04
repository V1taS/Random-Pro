//
//  DateTimeScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct DateTimeScreenModel: Codable, DateTimeScreenModelProtocol {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}

// MARK: - toCodable

extension DateTimeScreenModelProtocol {
  func toCodable() -> DateTimeScreenModel? {
    return DateTimeScreenModel(result: result,
                               listResult: listResult)
  }
}
