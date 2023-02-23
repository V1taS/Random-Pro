//
//  NotificationService.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - NotificationServiceProtocol

public protocol NotificationServiceProtocol {
  
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
