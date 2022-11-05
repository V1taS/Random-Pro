//
//  ObjectUserDefaultsWrapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Враперр для стандартных Object. Например: `Int, Double, String, [Float]...`
///
/// Пример использования
///
/// `@ObjectUserDefaultsWrapper<T>(key: "Уникальный ключ")private var object: T?`
///

/// Сгруппировали нужные протоколы
typealias ObjectUserDefaultsProtocol = Equatable & Encodable & Decodable

@propertyWrapper
struct ObjectUserDefaultsWrapper<T: ObjectUserDefaultsProtocol> {
  
  // MARK: - Internal property
  
  var wrappedValue: T? {
    get {
      let object: T? = UserDefaultsWrapper.object(for: key)
      return object
    }
    set {
      UserDefaultsWrapper.set(newValue, for: key)
    }
  }
  
  // MARK: - Private property
  
  private let key: String
  
  // MARK: - Initialization
  
  init(key: String) {
    self.key = key
  }
}
