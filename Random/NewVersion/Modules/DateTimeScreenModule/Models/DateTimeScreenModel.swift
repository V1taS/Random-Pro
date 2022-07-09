//
//  DateTimeScreenModel.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct DateTimeScreenModel: UserDefaultsCodable, SettingsScreenModel {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}
