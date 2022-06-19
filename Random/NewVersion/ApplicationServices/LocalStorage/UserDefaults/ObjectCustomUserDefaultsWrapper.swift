//
//  ObjectCustomUserDefaultsWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

/// Враперр для Object Custom
///
/// Пример использования
///
/// `@ObjectCustomUserDefaultsWrapper<T>(key: "Уникальный ключ")private var object: T?`
///

/// Сгруппировали нужные протоколы
typealias ObjectCustomUserDefaultsProtocol = Equatable & Encodable & Decodable

@propertyWrapper
struct ObjectCustomUserDefaultsWrapper<T: ObjectCustomUserDefaultsProtocol> {
  
  // MARK: - Internal property
  
  var wrappedValue: T? {
    get {
      let object: T? = UserDefaultsWrapper.objectCustom(for: key)
      return object
    }
    set {
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
