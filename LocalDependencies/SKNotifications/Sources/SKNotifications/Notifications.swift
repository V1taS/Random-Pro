//
//  Notifications.swift
//
//
//  Created by Vitalii Sosin on 08.07.2022.
//

import UIKit

/// Сервис по показу уведомлений
public class Notifications {
  
  // MARK: - Private properties
  
  private let animator = Animator()
  private weak var currentBanner: UIView?
  private var action: (() -> Void)?
  private var baners: [NotificationsModel] = []
  private var throttleTimer: Timer?
  private var dismissTimer: Timer?
  
  // MARK: - Initialization
  
  public init() {}
  
  // MARK: - Public func
  
  /// Показать уведомление
  ///  - Parameter model: Модель
  public func showAlertWith(model: NotificationsModel) {
    if baners.isEmpty {
      animateIn(model)
    }
    
    baners.append(model)
    
    guard let timer = throttleTimer, timer.isValid else {
      throttleTimer = createThrottleTimer(throttleDelay: model.throttleDelay)
      return
    }
  }
  
  /// Скрыть все уведомления
  public func dismissAll() {
    dismissCurrentBanner()
  }
}

// MARK: - Private

private extension Notifications {
  func animateIn(_ model: NotificationsModel) {
    let newBanner = NotificationsView()
    let image = model.glyph ? model.style.imageResource : nil
    newBanner.configureViewWith(
      NotificationsView.Model(body: model.body,
                              bodyColor: model.bodyColor,
                              backgroundColor: model.style.backgroundColor,
                              colorGlyph: model.style.colorGlyph,
                              glyph: image)
    )
    action = model.action
    animator.animateTransition(from: currentBanner, to: newBanner)
    currentBanner = newBanner
    updateDismissTimer(timeout: model.timeout ?? timeout(for: model.style))
    
    newBanner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeAction)))
    newBanner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
  }
  
  func createThrottleTimer(throttleDelay: Double) -> Timer {
    let timer = Timer(timeInterval: throttleDelay, target: self, selector: #selector(throttleTimerTick), userInfo: nil, repeats: true)
    timer.tolerance = Appearance().timerTolerance
    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    return timer
  }
  
  func timeout(for style: NotificationsModel.Style) -> TimeInterval {
    switch style {
    case .neutral:
      return Appearance().timeoutIntervalMax
    case .negative, .positive, .custom:
      return Appearance().timeoutIntervalMin
    }
  }
  
  func updateDismissTimer(timeout: TimeInterval) {
    dismissTimer?.invalidate()
    let timer = Timer(timeInterval: timeout, target: self, selector: #selector(dismissTimerTick), userInfo: nil, repeats: false)
    timer.tolerance = Appearance().timerTolerance
    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    dismissTimer = timer
  }
  
  func dismissCurrentBanner() {
    if animator.isAnimatingPan {
      animator.dismissWhenAvailable()
    } else {
      animator.animateDismiss(currentBanner)
    }
  }
  
  @objc
  func throttleTimerTick() {
    guard !baners.isEmpty else {
      throttleTimer?.invalidate()
      return
    }
    
    baners.removeFirst()
    
    if let first = baners.first {
      animateIn(first)
    } else {
      throttleTimer?.invalidate()
    }
  }
  
  @objc
  func dismissTimerTick() {
    dismissCurrentBanner()
  }
  
  @objc
  func swipeAction(sender: UIPanGestureRecognizer) {
    animator.animatePan(with: sender)
  }
  
  @objc
  func tapAction() {
    animator.animateTap(currentBanner)
    action?()
    action = nil
  }
}

// MARK: - Appearance

private extension Notifications {
  struct Appearance {
    let timerTolerance = 0.1
    let timeoutIntervalMax: Double = 10
    let timeoutIntervalMin: Double = 5
  }
}
