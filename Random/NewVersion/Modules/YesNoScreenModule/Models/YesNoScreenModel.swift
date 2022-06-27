//
//  YesNoScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

struct YesNoScreenModel: Equatable & Encodable & Decodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}
