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
  func startTimerWith(seconds: Int,
                      timerTickAction: ((_ currentTime: Int) -> Void)?,
                      timerFinishedAction: (() -> Void)?)
  
  /// Остановить таймер
  func stopTimer()
}

final class TimerServiceImpl: TimerService {
  
  // MARK: - Private property
  
  private var timer: Timer?
  private var repeatTime: Int = .zero
  private var backgroundDate: Date?
  private var timerTickAction: ((Int) -> Void)?
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
  
  func startTimerWith(seconds: Int,
                      timerTickAction: ((_ currentTime: Int) -> Void)? = nil,
                      timerFinishedAction: (() -> Void)? = nil) {
    repeatTime = seconds
    self.timerTickAction = timerTickAction
    self.timerFinishedAction = timerFinishedAction
    
    let timer = Timer.scheduledTimer(timeInterval: 1.0,
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
  func currentTime() -> Int {
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
      timerTickAction?(currentTime)
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
    if let backgroundDate,
       let secondsPast = Calendar.current.dateComponents([.second],
                                                         from: backgroundDate,
                                                         to: appStartDate).second {
      repeatTime -= secondsPast
    }
    startTimerWith(seconds: repeatTime)
  }
}
