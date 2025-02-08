//
//  HapticService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol HapticService {

  /// Запустить обратную связь от моторчика
  /// - Parameters:
  ///  - isRepeat: Повтор
  ///  - patternType: Шаблон вибрации
  ///  - completion: Результат завершения
  func play(isRepeat: Bool,
            patternType: HapticPatternType,
            completion: (Result<Void, HapticError>) -> Void)

  /// Остановить обратную связь от моторчика
  func stop()
}
