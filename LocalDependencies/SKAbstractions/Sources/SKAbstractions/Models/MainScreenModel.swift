//
//  MainScreenModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import UIKit

// MARK: - MainScreenModel

public struct MainScreenModel: UserDefaultsCodable {

  /// Темная тема включена
  public let isDarkMode: Bool?

  /// Доступность премиума в приложении
  public var isPremium: Bool

  /// Все секции приложения
  public var allSections: [Section]

  /// Публичный инициализатор для MainScreenModel
  public init(isDarkMode: Bool? = nil, isPremium: Bool, allSections: [Section]) {
    self.isDarkMode = isDarkMode
    self.isPremium = isPremium
    self.allSections = allSections
  }

  // MARK: - Section

  public struct Section: UserDefaultsCodable, Hashable {

    /// Тип секции
    public let type: SectionType

    /// Секция включена
    public let isEnabled: Bool

    /// Секция скрыта
    public var isHidden: Bool

    /// Секция входит в состав премиум (Платные секции)
    public let isPremium: Bool

    /// Тип лайбла
    public let advLabel: ADVLabel

    /// Описание в секции
    public var advDescription: String?

    /// Ссылка по рекламе
    public var advStringURL: String?

    /// Публичный инициализатор для Section
    public init(
      type: SectionType,
      isEnabled: Bool,
      isHidden: Bool,
      isPremium: Bool,
      advLabel: ADVLabel,
      advDescription: String? = nil,
      advStringURL: String? = nil
    ) {
      self.type = type
      self.isEnabled = isEnabled
      self.isHidden = isHidden
      self.isPremium = isPremium
      self.advLabel = advLabel
      self.advDescription = advDescription
      self.advStringURL = advStringURL
    }
  }
}
