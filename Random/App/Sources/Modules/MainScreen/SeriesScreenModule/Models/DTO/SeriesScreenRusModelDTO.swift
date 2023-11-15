//
//  SeriesScreenRusModelDTO.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SeriesScreenRusModelDTO: Codable {

  /// Список сериалов
  let films: [Series]

  // MARK: - Series

  struct Series: Codable {

    /// Название сериала
    let nameRu: String

    /// Жанры сериала
    let genres: [Genre]

    /// Год выпуска сериала
    let year: String

    /// URL Картинки
    let posterUrl: String
  }

  // MARK: - Genre

  struct Genre: Codable {

    /// Жанр сериала
    let genre: String
  }
}

