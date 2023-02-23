//
//  KeychainWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import KeychainSwift

enum KeychainWrapper {
  /// Универсальная функция, сохраняет любые `НЕ СТАНДАРТНЫЕ` объекты. Например: `UIImage, SelfType, Data...`
  static func setCustom<T: Encodable>(_ object: T, for key: String) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(object) {
      let keychain = KeychainSwift()
      keychain.synchronizable = true
      keychain.set(encoded, forKey: key)
    }
  }
  
  /// Универсальная функция, получает любые `НЕ СТАНДАРТНЫЕ` объекты. Например: `UIImage, SelfType, Data...`
  static func objectCustom<T: Decodable>(for key: String) -> T? {
    let keychain = KeychainSwift()
    keychain.synchronizable = true
    guard let items = keychain.getData(key) else { return nil }
    let decoder = JSONDecoder()
    if let decoded = try? decoder.decode(T.self, from: items) {
      return decoded
    } else {
      return nil
    }
  }
}
