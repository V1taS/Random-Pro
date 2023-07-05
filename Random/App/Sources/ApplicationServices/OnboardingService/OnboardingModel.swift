//
//  OnboardingModel.swift
//  Random
//
//  Created by Artem Pavlov on 30.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct OnboardingScreenModel: UserDefaultsCodable {

  // Была ли просмотрена онбоардинг страница
  let isWatched: Bool

  // Данные онбоардинг страницы
  let onboardingData: OnboardingData

  // MARK: - OnboardingData

  struct OnboardingData: UserDefaultsCodable {
    /// Название онбоардинг страницы
    let title: String

    /// Данные полей онбоардинг страницы
    let contents: [Content]
  }

  // MARK: - Content

  struct Content: UserDefaultsCodable {

    /// Название символа symbolsSF
    let symbolsSF: String

    /// Название поля онбоардинг страницы
    let title: String

    /// Описание поля онбоардинг страницы
    let description: String
  }
}
