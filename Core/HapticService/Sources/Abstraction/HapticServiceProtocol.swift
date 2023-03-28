//
//  HapticServiceProtocol.swift
//  HapticService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - HapticServiceProtocol

public protocol HapticServiceProtocol {
  
  /// Запустить обратную связь от моторчика
  /// - Parameters:
  ///  - isRepeat: Повтор
  ///  - completion: Результат завершения
  func play(isRepeat: Bool,
            completion: (Result<Void, Error>) -> Void)
  
  /// Остановить обратную связь от моторчика
  func stop()
}
