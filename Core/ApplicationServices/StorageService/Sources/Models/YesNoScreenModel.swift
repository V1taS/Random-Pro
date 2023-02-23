//
//  YesNoScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

struct YesNoScreenModel: Codable, YesNoScreenModelProtocol {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}

// MARK: - toCodable

extension YesNoScreenModelProtocol {
  func toCodable() -> YesNoScreenModel? {
    return YesNoScreenModel(result: result,
                            listResult: listResult)
  }
}
