//
//  SeriesScreenEngModelDTO.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SeriesScreenEngModelDTO: Codable {
  
  // MARK: - Series
  
  /// Название сериала
  let name: String?

  /// Год выпуска сериала
  let premiered: String?

  /// URL Картинки
  let image: SeriesImage?

  /// Жанры сериала
  let genres: [String]?

  // MARK: - SeriesImage
  
  struct SeriesImage: Codable {
    let original: String?
  }
}
