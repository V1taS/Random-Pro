//
//  NotificationService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import Notifications

protocol NotificationService {
  
  /// Показать позитивное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  func showPositiveAlertWith(title: String,
                             glyph: Bool)
  
  /// Показать нейтральное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  func showNeutralAlertWith(title: String,
                            glyph: Bool)
  
  /// Показать негативное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  func showNegativeAlertWith(title: String,
                             glyph: Bool)
  
  /// Показать настраиваемое уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  ///   - backgroundColor: Фон уведомления
  ///   - imageGlyph: Иконка слева
  ///   - colorGlyph: Цвет иконки
  func showCustomAlertWith(title: String,
                           glyph: Bool,
                           backgroundColor: UIColor?,
                           imageGlyph: UIImage?,
                           colorGlyph: UIColor?)
}

final class NotificationServiceImpl: NotificationService {
  private let notifications = Notifications()
  
  func showPositiveAlertWith(title: String, glyph: Bool) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        style: .positive,
        timeout: appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: {}
      )
    )
  }
  
  func showNeutralAlertWith(title: String, glyph: Bool) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        style: .neutral,
        timeout: appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: {}
      )
    )
  }
  
  func showNegativeAlertWith(title: String, glyph: Bool) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        style: .negative,
        timeout: appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: {}
      )
    )
  }
  
  func showCustomAlertWith(title: String,
                           glyph: Bool,
                           backgroundColor: UIColor?,
                           imageGlyph: UIImage?,
                           colorGlyph: UIColor?) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        style: .custom(
          backgroundColor: backgroundColor,
          glyph: imageGlyph,
          colorGlyph: colorGlyph
        ),
        timeout: appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: {}
      )
    )
  }
}

// MARK: - Appearance

private extension NotificationServiceImpl {
  struct Appearance {
    let timeout: Double = 2
    let throttleDelay: Double = 0.5
    let systemFontSize: CGFloat = 44
  }
}
