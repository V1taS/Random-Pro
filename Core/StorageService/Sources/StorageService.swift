//
//  StorageService.swift
//  StorageService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public final class StorageServiceImpl: StorageServiceProtocol {
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Public property
  
  public var isPremium: Bool {
    return mainScreenModelUserDefaults?.isPremium ?? false
  }
  
  public func saveData<T: Codable>(_ data: T, key: String) {
    @ObjectCustomUserDefaultsWrapper(key: key)
    var mainScreenModelUserDefaults: T?
    @ObjectCustomKeychainWrapper(key: key)
    var mainScreenModelKeychain: T?
    
    mainScreenModelUserDefaults = data
    mainScreenModelKeychain = data
  }
  
  public func getDataWith<ResponseType: Codable>(key: String, to _: ResponseType.Type) -> ResponseType? {
    @ObjectCustomUserDefaultsWrapper(key: key)
    var mainScreenModelUserDefaults: Data?
    @ObjectCustomKeychainWrapper(key: key)
    var mainScreenModelKeychain: Data?
    let data: Data? = isPremium ? mainScreenModelKeychain : mainScreenModelUserDefaults
    
    guard let data else {
      return nil
    }
    
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(ResponseType.self, from: data)
      return result
    } catch {
      return nil
    }
  }
  
  // MARK: - Main model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelUserDefaults: MainScreenIsPremiumModel?
  @ObjectCustomKeychainWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelKeychain: MainScreenIsPremiumModel?
}

// MARK: - Private

private extension StorageServiceImpl {}

// MARK: - Appearance

private extension StorageServiceImpl {
  struct Appearance {
    let mainScreenKeyUserDefaults = "main_screen_user_defaults_key"
  }
}
