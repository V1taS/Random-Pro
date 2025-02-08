//
//  HapticError.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

/// Ошибки запуска обратной связи от моторчика
public enum HapticError: Error {

  /// Обратную связь от моторчика не поддерживается
  case notSupported

  /// Не получилось создать Обратную связь
  case hapticEngineCreationError(Error)

  /// Ошибка воспроизведения
  case failedToPlay(Error)

  /// Ошибка создания шаблона
  case failedCreationPattern(Error)
}
