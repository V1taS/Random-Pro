//
//  UIViewControllerPreview.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 17.04.2024.
//

import SwiftUI

/// `UIViewControllerPreview` предоставляет обёртку для интеграции `UIViewController` в SwiftUI.
///
/// Эта структура использует замыкание для создания экземпляра `UIViewController`, что позволяет легко вставить любой контроллер в предпросмотры SwiftUI.
/// Для использования необходимо передать замыкание, которое инициализирует и возвращает желаемый `UIViewController`.
///
/// - Parameters:
///   - ViewController: Тип `UIViewController`, который будет интегрирован.
public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
  /// Экземпляр `ViewController`, который будет отображаться в SwiftUI.
  let viewController: ViewController
  
  /// Инициализатор для `UIViewControllerPreview`.
  ///
  /// - Parameter builder: Замыкание, возвращающее экземпляр `ViewController`.
  ///   Это замыкание вызывается один раз при инициализации `UIViewControllerPreview`.
  public init(_ builder: @escaping () -> ViewController) {
    viewController = builder()
  }
  
  /// Создаёт `UIViewController` и возвращает его.
  /// Этот метод вызывается SwiftUI при создании представления.
  ///
  /// - Parameter context: Контекст с информацией о текущем состоянии представления.
  /// - Returns: Экземпляр `ViewController`, который будет вставлен в SwiftUI представление.
  public func makeUIViewController(context: Context) -> ViewController {
    viewController
  }
  
  /// Обновляет состояние `UIViewController` в SwiftUI представлении.
  /// Этот метод вызывается SwiftUI при обновлении представления.
  ///
  /// - Parameters:
  ///   - uiViewController: Контроллер, который нужно обновить.
  ///   - context: Контекст с информацией о текущем состоянии и связях в SwiftUI представлении.
  public func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
