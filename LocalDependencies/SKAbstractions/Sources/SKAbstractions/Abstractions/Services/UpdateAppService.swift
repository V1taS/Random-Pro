//
//  UpdateAppService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol UpdateAppService {

  /// Проверить доступность нового обновления для приложения
  func checkIsUpdateAvailable(isOneCheckVersion: Bool,
                              completion: @escaping (Result<UpdateAppServiceModel, UpdateAppServiceError>) -> Void)
}
