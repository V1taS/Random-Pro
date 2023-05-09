//
//  TimerService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 26.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol TimerService {
  
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

final class TimerServiceImpl: TimerService {
  
  // MARK: - Private property
  
  private var timer: Timer?
  private var repeatTime: Double = .zero
  private var backgroundDate: Date?
  private var timerTickAction: ((Double) -> Void)?
  private var timerFinishedAction: (() -> Void)?
  
  // MARK: - Initialization
  
  init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appPaused),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appStarted),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
  }
  
  // MARK: - Deinitialization
  
  deinit {
    stopTimer()
  }
  
  // MARK: - Internal func
  
  func startTimerWith(seconds: Double,
                      timerTickAction: ((_ currentTime: Double) -> Void)? = nil,
                      timerFinishedAction: (() -> Void)? = nil) {
    repeatTime = seconds * 100
    self.timerTickAction = timerTickAction
    self.timerFinishedAction = timerFinishedAction
    
    let timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    self.timer = timer
    timer.fire()
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
}

// MARK: - Private

private extension TimerServiceImpl {
  func currentTime() -> Double {
    repeatTime -= 1
    return repeatTime
  }
  
  @objc
  func updateTimer() {
    let currentTime = currentTime()
    if currentTime <= .zero {
      stopTimer()
      timerFinishedAction?()
    } else {
      timerTickAction?(currentTime / 100)
    }
  }
  
  @objc
  func appPaused() {
    timer?.invalidate()
    timer = nil
    backgroundDate = Date()
  }
  
  @objc
  func appStarted() {
    let appStartDate = Date()
    guard let backgroundDate = backgroundDate,
          let nanosecond = Calendar.current.dateComponents([.nanosecond],
                                                           from: backgroundDate,
                                                           to: appStartDate).nanosecond else {
      startTimerWith(seconds: repeatTime)
      return
    }
    
    let secondstime = Double(nanosecond) / 1000000
    repeatTime -= secondstime
    startTimerWith(seconds: repeatTime)
  }
}
