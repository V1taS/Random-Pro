//
//  TimerService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol TimerService {

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
