//
//  StorageService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

public final class StorageServiceImpl: StorageService {
  public init() {}

  // MARK: - Internal property
  
  public var isPremium: Bool {
    let describingType = String(describing: MainScreenModel.self)
    let key = "\(describingType)_data"
    @ObjectCustomKeychainWrapper(key: key)
    var dataKeychain: MainScreenModel?
    return dataKeychain?.isPremium ?? false
  }
  
  // MARK: - Internal func
  
  public func saveData<T: UserDefaultsCodable>(_ data: T?) {
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
  
  public func getData<T: UserDefaultsCodable>(from: T.Type) -> T? {
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
