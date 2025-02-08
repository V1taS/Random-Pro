//
//  ViewController.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit

/// `ViewController` является базовым классом контроллера представления,
/// который предоставляет методы для управления жизненным циклом контроллера.
open class ViewController: UIViewController {
  
  /// Кэш экрана
  private var cacheNavigationController: UINavigationController?
  
  /// Завершает текущий процесс. По умолчанию ничего не делает, может быть переопределено подклассами.
  open func finishFlow() {}
  
  /// Метод вызывается после загрузки представления контроллера в память.
  ///  Добавляет текущий контроллер в `ViewControllerManager`.
  open override func viewDidLoad() {
    super.viewDidLoad()
    ViewControllerManager.shared.add(self)
  }
  
  /// Метод вызывается перед исчезновением представления контроллера.
  /// При уходе контроллера отправляет уведомление для проверки активных контроллеров.
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    cacheNavigationController = self.navigationController
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.post(
      name: Notification.Name(Constants.notificationCenterKey),
      object: cacheNavigationController
    )
    cacheNavigationController = nil
  }
}

/// `ViewControllerManager` - это синглтон, отслеживающий текущие активные контроллеры представления в приложении.
final class ViewControllerManager {
  static let shared = ViewControllerManager()
  
  private var viewControllers: [UIViewController] = []
  
  /// Конструктор инициализирует уведомление для проверки активных контроллеров в стеке.
  init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(checkViewControllersInStack),
      name: Notification.Name(Constants.notificationCenterKey),
      object: nil
    )
  }
  
  /// Удаляет наблюдателя уведомлений при уничтожении объекта.
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  /// Добавляет контроллер представления в список активных контроллеров.
  func add(_ viewController: UIViewController) {
    viewControllers.append(viewController)
  }
  
  // MARK: - Private
  
  /// Проверяет контроллеры в стеке `navigationController` и удаляет из списка, если они отсутствуют.
  /// При удалении вызывает `finishFlow` у соответствующего контроллера.
  @objc
  private func checkViewControllersInStack(notification: Notification) {
    guard let navigationController = notification.object as? UINavigationController else { return }
    
    while let lastVC = viewControllers.last,
          !navigationController.viewControllers.contains(lastVC) {
      viewControllers.removeLast()
      (lastVC as? ViewController)?.finishFlow()
    }
  }
}

// MARK: - Constants

/// Константы, используемые в контексте управления контроллерами представления.
private enum Constants {
  static let notificationCenterKey = "ViewControllerNotificationCenter"
}
