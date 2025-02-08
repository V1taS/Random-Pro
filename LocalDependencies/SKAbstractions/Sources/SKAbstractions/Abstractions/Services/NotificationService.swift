//
//  NotificationService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation
import UIKit

public protocol NotificationService {

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
