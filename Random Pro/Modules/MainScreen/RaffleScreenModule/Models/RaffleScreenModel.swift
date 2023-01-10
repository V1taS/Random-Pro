//
//  RaffleScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct RaffleScreenModel: UserDefaultsCodable {
  
  /// Аватарка пользователя
  let avatar: Data?
  
  /// ИД пользователя
  let identifier: String?
  
  /// Полное имя пользователя
  let fullName: String?
  
  /// Почта пользователя
  let email: String?
}
