//
//  TouchObservingWindow.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 15.09.2024.
//

import UIKit

/// Окно, которое перехватывает события касания по всему экрану, оставаясь невидимым для пользователя.
public final class TouchObservingWindow: UIWindow {
  
  // MARK: - Public init
  
  /// Создает и отображает окно на весь экран, которое невидимо для пользователя и способно перехватывать события касания.
  public override init(windowScene: UIWindowScene?) {
    super.init(frame: UIScreen.main.bounds)
    self.windowScene = windowScene
    makeKeyAndVisible()
  }
  
  /// Инициализатор из storyboard не поддерживается.
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Отправляет событие и уведомляет об этом через NotificationCenter при начале касания.
  public override func sendEvent(_ event: UIEvent) {
    super.sendEvent(event)
    if event.type == .touches, let touches = event.allTouches {
      for touch in touches {
        if touch.phase == .began {
          // Обрабатываем событие касания
          NotificationCenter.default.post(name: .globalTouchEvent, object: touch)
        }
      }
    }
  }
}

/// Расширение для удобного доступа к имени уведомления о глобальном касании.
public extension Notification.Name {
  /// Уведомление, отправляемое при глобальном событии касания.
  static let globalTouchEvent = Notification.Name("GlobalTouchEvent")
}
