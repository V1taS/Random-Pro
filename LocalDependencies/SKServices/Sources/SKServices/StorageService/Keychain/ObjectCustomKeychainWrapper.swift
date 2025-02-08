//
//  ObjectCustomKeychainWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

/// Враперр для Object Custom
///
/// Пример использования
///
/// `@ObjectCustomKeychainWrapper(key: "Уникальный ключ")private var object: T?`
///

@propertyWrapper
struct ObjectCustomKeychainWrapper<T: UserDefaultsCodable> {
  
  // MARK: - Internal property
  
  var wrappedValue: T? {
    get {
      let object: T? = KeychainWrapper.objectCustom(for: key)
      return object
    } set {
      KeychainWrapper.setCustom(newValue, for: key)
    }
  }
  
  // MARK: - Private property
  
  private let key: String
  
  // MARK: - Initialization
  
  init(key: String) {
    self.key = key
  }
}
