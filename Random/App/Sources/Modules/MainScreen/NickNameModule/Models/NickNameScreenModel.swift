//
//  NickNameScreenModel.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct NickNameScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}
