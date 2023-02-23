//
//  NotificationService.swift
//  NotificationService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit
import Notifications
import ApplicationInterface

public final class NotificationServiceImpl: NotificationServiceProtocol {
  
  // MARK: - Private property
  
  private let notifications = Notifications()
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Public func
  
  public func showPositiveAlertWith(title: String,
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
  
  public func showNeutralAlertWith(title: String,
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
  
  public func showNegativeAlertWith(title: String,
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
  
  public func showCustomAlertWith(title: String,
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
