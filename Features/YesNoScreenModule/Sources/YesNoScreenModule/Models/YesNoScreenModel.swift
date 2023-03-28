//
//  YesNoScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct YesNoScreenModel: Codable {
  
  /// Результат генерации
  public let result: String
  
  /// Список результатов
  public let listResult: [String]
}
