//
//  TimerService.swift
//  TimerService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class TimerServiceImpl: TimerServiceProtocol {
  
  // MARK: - Private property
  
  private var timer: Timer?
  private var repeatTime: Double = .zero
  private var backgroundDate: Date?
  private var timerTickAction: ((Double) -> Void)?
  private var timerFinishedAction: (() -> Void)?
  
  // MARK: - Initialization
  
  public init() {
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
  
  public func startTimerWith(seconds: Double,
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
  
  public func stopTimer() {
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
