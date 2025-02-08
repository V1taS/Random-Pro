//
//  DateTimeScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct DateTimeScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}
