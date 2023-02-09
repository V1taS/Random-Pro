//
//  UserDefaultsWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

enum UserDefaultsWrapper {
  /// Универсальная функция, сохраняет любые `НЕ СТАНДАРТНЫЕ` объекты. Например: `UIImage, SelfType, Data...`
  static func setCustom<T: Equatable & Encodable>(_ object: T, for key: String) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(object) {
      UserDefaults.standard.set(encoded, forKey: key)
    }
  }
  
  /// Универсальная функция, получает любые `НЕ СТАНДАРТНЫЕ` объекты. Например: `UIImage, SelfType, Data...`
  static func objectCustom<T: Equatable & Decodable>(for key: String) -> T? {
    guard let items = UserDefaults.standard.data(forKey: key) else { return nil }
    let decoder = JSONDecoder()
    if let decoded = try? decoder.decode(T.self, from: items) {
      return decoded
    } else {
      return nil
    }
  }
}
