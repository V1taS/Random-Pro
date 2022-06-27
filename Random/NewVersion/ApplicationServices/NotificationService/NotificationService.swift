//
//  NotificationService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import RandomUIKit
import NotificationBannerSwift

protocol NotificationService {
  
  /// Показать алерт успеха
  ///  - Parameters:
  ///   - title: Заголовок алерта
  ///   - subtitle: Описание алерта
  ///   - bannerPosition: Позиция алерта
  func showSuccess(title: String?,
                   subtitle: String?,
                   bannerPosition: NotificationServiceImpl.BannerPosition)
  
  /// Показать алерт успеха
  ///  - Parameters:
  ///   - title: Заголовок алерта
  ///   - subtitle: Описание алерта
  ///   - bannerPosition: Позиция алерта
  func showError(title: String?,
                 subtitle: String?,
                 bannerPosition: NotificationServiceImpl.BannerPosition)
  
  /// Показать алерт успеха
  ///  - Parameters:
  ///   - title: Заголовок алерта
  ///   - subtitle: Описание алерта
  ///   - bannerPosition: Позиция алерта
  func showWarning(title: String?,
                   subtitle: String?,
                   bannerPosition: NotificationServiceImpl.BannerPosition)
}

final class NotificationServiceImpl: NotificationService {
  
  /// Позиция баннера
  enum BannerPosition {
    
    /// Сверху
    case top
    
    /// Снизу
    case bottom
  }
  
  // MARK: - Internal func
  
  func showSuccess(title: String?,
                   subtitle: String?,
                   bannerPosition: NotificationServiceImpl.BannerPosition = .top) {
    guard title != nil || subtitle != nil else {
      return
    }
    
    let bannerPosition: NotificationBannerSwift.BannerPosition = bannerPosition == .top ? .top : .bottom
    let banner = NotificationBanner(title: title,
                                    subtitle: subtitle,
                                    style: .success)
    
    if title == nil {
      banner.applyStyling(subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    if subtitle == nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center)
    }
    
    if title != nil && subtitle != nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center,
                          subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    banner.show(queuePosition: .back,
                bannerPosition: bannerPosition,
                queue: .default)
    
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    banner.duration = 0.4
  }
  
  func showError(title: String?,
                 subtitle: String?,
                 bannerPosition: NotificationServiceImpl.BannerPosition = .top) {
    guard title != nil || subtitle != nil else {
      return
    }
    
    let bannerPosition: NotificationBannerSwift.BannerPosition = bannerPosition == .top ? .top : .bottom
    let banner = NotificationBanner(title: title,
                                    subtitle: subtitle,
                                    style: .danger)
    
    if title == nil {
      banner.applyStyling(subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    if subtitle == nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center)
    }
    
    if title != nil && subtitle != nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center,
                          subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    banner.show(queuePosition: .back,
                bannerPosition: bannerPosition,
                queue: .default)
    
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    banner.duration = 0.4
  }
  
  func showWarning(title: String?,
                   subtitle: String?,
                   bannerPosition: NotificationServiceImpl.BannerPosition = .top) {
    guard title != nil || subtitle != nil else {
      return
    }
    
    let bannerPosition: NotificationBannerSwift.BannerPosition = bannerPosition == .top ? .top : .bottom
    let banner = NotificationBanner(title: title,
                                    subtitle: subtitle,
                                    style: .warning)
    
    if title == nil {
      banner.applyStyling(subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    if subtitle == nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center)
    }
    
    if title != nil && subtitle != nil {
      banner.applyStyling(titleColor: RandomColor.primaryWhite,
                          titleTextAlign: .center,
                          subtitleColor: RandomColor.primaryWhite,
                          subtitleTextAlign: .center)
    }
    
    banner.show(queuePosition: .back,
                bannerPosition: bannerPosition,
                queue: .default)
    
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    banner.duration = 0.4
  }
}
