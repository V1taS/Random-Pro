//
//  YesNoScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
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
