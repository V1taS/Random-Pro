//
//  MainScreenModel+ADVLabel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import Foundation

extension MainScreenModel {

  // MARK: - ADVLabel

  public enum ADVLabel: CaseIterable, UserDefaultsCodable, Hashable {
    public static var allCases: [MainScreenModel.ADVLabel] = [.hit, .new, .none, .custom(text: ""), .ai, .adv]

    /// Лайбл: `ХИТ`
    case hit

    /// Лайбл: `НОВОЕ`
    case new

    /// Текст с бека
    case custom(text: String)

    /// Реклама
    case adv

    /// Искуственный интелект
    case ai

    /// Лайбл: `Пусто`
    case none
  }
}
