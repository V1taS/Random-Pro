//
//  UpdateAppServiceError.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum UpdateAppServiceError: Error {

  /// Ошибка в получении данных
  case invalidResponse

  /// Ошибка в данных
  case invalidData

  /// Ошибка в Bundle Info
  case invalidBundleInfo

  /// Что-то пошло не так
  case somethingWrongWith(String?)
}
