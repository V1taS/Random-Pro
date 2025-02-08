//
//  UpdateAppServiceModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public struct UpdateAppServiceModel {

  /// Доступность нового обновления в App Store
  public let isUpdateAvailable: Bool

  /// Новая версия приложения в App Store
  public let appStoreVersion: String

  /// Текущая версия на устройстве
  public let currentDeviceVersion: String

  /// Публичный инициализатор для UpdateAppServiceModel
  public init(isUpdateAvailable: Bool, appStoreVersion: String, currentDeviceVersion: String) {
    self.isUpdateAvailable = isUpdateAvailable
    self.appStoreVersion = appStoreVersion
    self.currentDeviceVersion = currentDeviceVersion
  }
}
