//
//  NotificationService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit
import Notifications

protocol NotificationService {
  
  /// Показать позитивное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  ///   - timeout: Продолжительность показа
  ///   - active: Действие на кнопку
  func showPositiveAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?)
  
  /// Показать нейтральное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  ///   - timeout: Продолжительность показа
  ///   - active: Действие на кнопку
  func showNeutralAlertWith(title: String,
                            glyph: Bool,
                            timeout: Double?,
                            active: (() -> Void)?)
  
  /// Показать негативное уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - glyph: Включена или выключена иконка
  ///   - timeout: Продолжительность показа
  ///   - active: Действие на кнопку
  func showNegativeAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?)
  
  /// Показать настраиваемое уведомление
  ///  - Parameters:
  ///   - title: Заголовок уведомления
  ///   - textColor: Цвет текста
  ///   - glyph: Включена или выключена иконка
  ///   - timeout: Продолжительность показа
  ///   - backgroundColor: Фон уведомления
  ///   - imageGlyph: Иконка слева
  ///   - colorGlyph: Цвет иконки
  ///   - active: Действие на кнопку
  func showCustomAlertWith(title: String,
                           textColor: UIColor?,
                           glyph: Bool,
                           timeout: Double?,
                           backgroundColor: UIColor?,
                           imageGlyph: UIImage?,
                           colorGlyph: UIColor?,
                           active: (() -> Void)?)
}

final class NotificationServiceImpl: NotificationService {
  private let notifications = Notifications()
  
  func showPositiveAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: .black,
        style: .positive(colorGlyph: .black),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
      )
    )
  }
  
  func showNeutralAlertWith(title: String,
                            glyph: Bool,
                            timeout: Double?,
                            active: (() -> Void)?) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: RandomColor.darkAndLightTheme.primaryGray,
        style: .neutral(colorGlyph: RandomColor.darkAndLightTheme.primaryGray),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
      )
    )
  }
  
  func showNegativeAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: .black,
        style: .negative(colorGlyph: .black),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
      )
    )
  }
  
  func showCustomAlertWith(title: String,
                           textColor: UIColor?,
                           glyph: Bool,
                           timeout: Double?,
                           backgroundColor: UIColor?,
                           imageGlyph: UIImage?,
                           colorGlyph: UIColor?,
                           active: (() -> Void)?) {
    let appearance = Appearance()
    
    notifications.showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: textColor,
        style: .custom(
          backgroundColor: backgroundColor,
          glyph: imageGlyph,
          colorGlyph: colorGlyph
        ),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
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
