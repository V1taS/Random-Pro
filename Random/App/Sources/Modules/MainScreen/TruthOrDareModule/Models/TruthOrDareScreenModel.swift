//
//  TruthOrDareScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct TruthOrDareScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String

  /// Список результатов
  let listResult: [String]
}
