//
//  HapticServiceProtocol.swift
//  HapticService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import CoreHaptics

// MARK: - HapticServiceProtocol

public protocol HapticServiceProtocol {
  
  /// Запустить обратную связь от моторчика
  /// - Parameters:
  ///  - isRepeat: Повтор
  ///  - patternType: Шаблон вибрации
  ///  - completion: Результат завершения
  func play(isRepeat: Bool,
            patternType: HapticServicePatternTypeProtocol,
            completion: (Result<Void, Error>) -> Void)
  
  /// Остановить обратную связь от моторчика
  func stop()
}

// MARK: - HapticServicePatternTypeProtocol

/// Шаблоны запуска обратной связи от моторчика
public protocol HapticServicePatternTypeProtocol {
  
  /// Два тактильных события
  static var slice: Self { get }
  
  /// Кормление крокодила
  static var feedingCrocodile: Self { get }
  
  /// Всплеск
  static var splash: Self { get }
}

// MARK: - HapticServiceErrorProtocol

/// Ошибки запуска обратной связи от моторчика
public protocol HapticServiceErrorProtocol: Error {
  
  /// Обратную связь от моторчика не поддерживается
  static var notSupported: Self { get }
  
  /// Не получилось создать Обратную связь
  static func hapticEngineCreationError(_ error: Error) -> Self
  
  /// Ошибка воспроизведения
  static func failedToPlay(_ error: Error) -> Self
  
  /// Ошибка создания шаблона
  static func failedCreationPattern(_ error: Error) -> Self
}
