//
//  OnboardingScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct OnboardingScreenModel: UserDefaultsCodable, Hashable {
  
  /// Заголовок
  let title: String?
  
  /// Описание
  let description: String?
  
  /// Изображение
  let image: Data?
  
  /// Разделы в онбоардинге
  let page: Page
  
  /// Просмотрена эта страница
  let isViewed: Bool
  
  // MARK: - Page
  
  enum Page: CaseIterable, UserDefaultsCodable, Hashable {
    
    /// Темная тема
    case darkTheme
    
    /// Настройка главного экрана
    case customSections
  }
}
