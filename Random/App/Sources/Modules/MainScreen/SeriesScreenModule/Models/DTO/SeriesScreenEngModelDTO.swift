//
//  SeriesScreenEngModelDTO.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SeriesScreenEngModelDTO: Codable {

  /// Список сериалов
  let items: [Series]

  // MARK: - Series

  struct Series: Codable {

    /// Название сериала
    let nameOriginal: String

    /// URL Картинки
    let posterUrl: String

    /// Год выпуска сериала
    let year: Int
  }
}
