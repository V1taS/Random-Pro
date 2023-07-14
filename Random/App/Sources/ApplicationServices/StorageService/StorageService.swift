//
//  StorageService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

protocol StorageService {

  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Сохранить данные
  /// - Parameter data: Данные
  func saveData<T: UserDefaultsCodable>(_ data: T?)
  
  /// Получить данные по Типу `Type.self`
  func getData<T: UserDefaultsCodable>(from: T.Type) -> T?
}

final class StorageServiceImpl: StorageService {
  
  // MARK: - Internal property

  var isPremium: Bool {
    let describingType = String(describing: MainScreenModel.self)
    let key = "\(describingType)_data"
    @ObjectCustomKeychainWrapper(key: key)
    var dataKeychain: MainScreenModel?
    return dataKeychain?.isPremium ?? false
  }
  
  // MARK: - Internal func
  
  func saveData<T: UserDefaultsCodable>(_ data: T?) {
    let describingType: String
    if let unwrappedData = data {
      describingType = String(describing: type(of: unwrappedData))
    } else {
      describingType = String(describing: T.self)
    }
    
    let key = "\(describingType)_data"
    @ObjectCustomUserDefaultsWrapper(key: key)
    var dataUserDefaults: T?
    @ObjectCustomKeychainWrapper(key: key)
    var dataKeychain: T?
    
    dataUserDefaults = data
    dataKeychain = data
  }
  
  func getData<T: UserDefaultsCodable>(from: T.Type) -> T? {
    let describingType = String(describing: from)
    let key = "\(describingType)_data"
    
    if isPremium {
      @ObjectCustomKeychainWrapper(key: key)
      var dataKeychain: T?
      return dataKeychain
    } else {
      @ObjectCustomUserDefaultsWrapper(key: key)
      var dataUserDefaults: T?
      return dataUserDefaults
    }
  }
}
