//
//  TimerServiceProtocol.swift
//  TimerService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - TimerServiceProtocol

public protocol TimerServiceProtocol {
  
  /// Запустить таймер
  /// - Parameters:
  ///  - seconds: Кол-во секунд в таймере
  ///  - timerTickAction: Экшен на  каждую секунда
  ///  - timerFinishedAction: Экшен на завершение таймера
  func startTimerWith(seconds: Double,
                      timerTickAction: ((_ currentTime: Double) -> Void)?,
                      timerFinishedAction: (() -> Void)?)
  
  /// Остановить таймер
  func stopTimer()
}
