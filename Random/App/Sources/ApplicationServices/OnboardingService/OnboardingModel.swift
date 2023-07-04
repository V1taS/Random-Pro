//
//  OnboardingModel.swift
//  Random
//
//  Created by Artem Pavlov on 30.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct OnboardingScreenModel: UserDefaultsCodable {

  /// Данные онбоардинг страницы
  let onboardingData: OnboardingData?

  /// Язык для онбоардинг экрана
  let language: Language?


// MARK: - OnboardingData

  struct OnboardingData: UserDefaultsCodable {

    /// Название онбоардинг страницы
    let title: String

    /// Данные полей онбоардинг страницы
    let contents: [Content]


    // MARK: - Content

  }

  struct Content: UserDefaultsCodable {

    /// Название символа symbolsSF
    let symbolsSF: String

    /// Название поля онбоардинг страницы
    let title: String

    /// Описание поля онбоардинг страницы
    let description: String
  }

  // MARK: - Language

  enum Language: String, UserDefaultsCodable {

    /// Английский
    case en

    /// Русский
    case ru
  }
}
