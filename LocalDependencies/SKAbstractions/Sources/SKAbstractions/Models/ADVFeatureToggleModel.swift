//
//  ADVFeatureToggleModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public struct ADVFeatureToggleModel: UserDefaultsCodable {

  /// Категория рекламы
  public let category: String?

  /// Текст рекламы на русском языке
  public let textADVRus: String?

  /// Текст рекламы на английском языке
  public let textADVEng: String?

  /// URL-адрес для перехода по рекламе
  public let urlString: String?

  /// Публичный инициализатор для ADVFeatureToggleModel
  public init(
    category: String? = nil,
    textADVRus: String? = nil,
    textADVEng: String? = nil,
    urlString: String? = nil
  ) {
    self.category = category
    self.textADVRus = textADVRus
    self.textADVEng = textADVEng
    self.urlString = urlString
  }
}
