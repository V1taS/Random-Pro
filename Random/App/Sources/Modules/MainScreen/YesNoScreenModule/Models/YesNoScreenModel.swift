//
//  YesNoScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct YesNoScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}
