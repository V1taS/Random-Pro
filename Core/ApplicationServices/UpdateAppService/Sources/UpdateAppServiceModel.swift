//
//  UpdateAppServiceModel.swift
//  UpdateAppService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public struct UpdateAppServiceModel: UpdateAppServiceModelProtocol {
  
  /// Доступность нового обновления в  App Store
  public let isUpdateAvailable: Bool
  
  /// Новая версия приложения в App Store
  public let appStoreVersion: String
  
  /// Текущая версия на устройстве
  public let currentDeviceVersion: String
}
