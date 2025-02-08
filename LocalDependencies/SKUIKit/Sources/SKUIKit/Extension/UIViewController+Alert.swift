//
//  UIViewController+Alert.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.05.2024.
//

import UIKit

extension UIViewController {
  /// Показывает алерт с одной кнопкой.
  /// - Parameters:
  ///   - title: Заголовок алерта.
  ///   - buttonText: Текст кнопки.
  ///   - message: Опциональное сообщение алерта.
  ///   - action: Действие, выполняемое при нажатии на кнопку.
  public func showAlertWithOneButton(
    title: String,
    buttonText: String,
    message: String = "",
    action: @escaping () -> Void
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let actionButton = UIAlertAction(title: buttonText, style: .default) { _ in
      action()
    }
    alert.addAction(actionButton)
    present(alert, animated: true)
  }
  
  /// Показывает алерт с двумя кнопками.
  /// - Parameters:
  ///   - title: Заголовок алерта.
  ///   - message: Опциональное сообщение алерта.
  ///   - cancelButtonText: Текст кнопки отмены.
  ///   - customButtonText: Текст второй кнопки.
  ///   - customButtonAction: Действие для второй кнопки (опционально).
  ///   - cancelButtonAction: Действие для кнопки отмены (опционально).
  public func showAlertWithTwoButtons(
    title: String,
    message: String = "",
    cancelButtonText: String,
    customButtonText: String,
    customButtonAction:  (() -> Void)?,
    cancelButtonAction: (() -> Void)? = nil
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelButton = UIAlertAction(title: cancelButtonText, style: .cancel) { _ in
      cancelButtonAction?()
    }
    let customButton = UIAlertAction(title: customButtonText, style: .destructive) { _ in
      customButtonAction?()
    }
    alert.addAction(cancelButton)
    alert.addAction(customButton)
    present(alert, animated: true)
  }
}
