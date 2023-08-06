//
//  ReferalError.swift
//  Random
//
//  Created by Vitalii Sosin on 04.08.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum ReferalError: Error {
  
  /// Ошибка в получении ИД
  case failedToGetIdentifier
  
  /// Ошибка в получении документа
  case failedGettingDocument(_ localizedDescription: String)
  
  /// Ошибка обновления документа
  case failedUpdatingDocument(_ localizedDescription: String)
  
  /// Ошибка обновления рефералов
  case failedToUpdateReferals
  
  /// Ошибка создания нового документа
  case failedCreatingNewDocument(_ localizedDescription: String)
  
  /// Уже существует
  case failedAlreadyExists
}
