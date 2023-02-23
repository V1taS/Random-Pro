//
//  UpdateAppServiceError.swift
//  UpdateAppService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public enum UpdateAppServiceError: UpdateAppServiceErrorProtocol {

  /// Ошибка в получении данных
  case invalidResponse

  /// Ошибка в данных
  case invalidData

  /// Ошибка в Bundle Info
  case invalidBundleInfo

  /// Что-то пошло не так
  case somethingWrongWith(String?)
}
