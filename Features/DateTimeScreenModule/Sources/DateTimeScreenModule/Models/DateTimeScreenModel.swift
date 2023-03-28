//
//  DateTimeScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct DateTimeScreenModel: Codable {
  
  /// Результат генерации
  public let result: String
  
  /// Список результатов
  public let listResult: [String]
}
