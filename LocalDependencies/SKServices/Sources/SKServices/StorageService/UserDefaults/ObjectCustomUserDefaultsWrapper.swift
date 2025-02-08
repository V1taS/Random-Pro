//
//  ObjectCustomUserDefaultsWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

/// Враперр для Object Custom
///
/// Пример использования
///
/// `@ObjectCustomUserDefaultsWrapper(key: "Уникальный ключ")private var object: T?`
///

@propertyWrapper
struct ObjectCustomUserDefaultsWrapper<T: UserDefaultsCodable> {
  
  // MARK: - Internal property
  
  var wrappedValue: T? {
    get {
      let object: T? = UserDefaultsWrapper.objectCustom(for: key)
      return object
    } set {
      UserDefaultsWrapper.setCustom(newValue, for: key)
    }
  }
  
  // MARK: - Private property
  
  private let key: String
  
  // MARK: - Initialization
  
  init(key: String) {
    self.key = key
  }
}
