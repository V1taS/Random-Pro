//
//  FilmsScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

struct FilmsScreenModel: Codable, FilmsScreenModelProtocol {
  
  /// Название фильма
  let name: String
  
  /// Описание фильма
  let description: String
  
  /// Изображение
  let image: Data?
  
  /// Ссылка на трейлер зарубежных фильмов
  var previewEngtUrl: String?
}

// MARK: - toCodable

extension [FilmsScreenModelProtocol] {
  func toCodable() -> [FilmsScreenModel] {
    let models = self.map {
      return FilmsScreenModel(name: $0.name,
                              description: $0.description,
                              image: $0.image,
                              previewEngtUrl: $0.previewEngtUrl)
    }
    return models
  }
}
