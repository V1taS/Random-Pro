//
//  UpdateAppServiceModel.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct UpdateAppServiceModel {

  /// Доступность нового обновления в  App Store
  let isUpdateAvailable: Bool

  /// Новая версия приложения в App Store
  let appStoreVersion: String

  /// Текущая версия на устройстве
  let currentDeviceVersion: String
}
