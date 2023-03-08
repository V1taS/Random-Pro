//
//  StorageService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

final class StorageServiceImpl {
  
  var listScreenModel: ListScreenModel? {
    get {
      listScreenModelUserDefaults
    } set {
      listScreenModelUserDefaults = newValue
    }
  }
  
  // MARK: - Private property
  
  // MARK: - List model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().listScreenModelKeyUserDefaults)
  private var listScreenModelUserDefaults: ListScreenModel?
}

// MARK: - Appearance

private extension StorageServiceImpl {
  struct Appearance {
    let listScreenModelKeyUserDefaults = "list_screen_user_defaults_key"
  }
}
