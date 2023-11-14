//
//  SeriesScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SeriesScreenModel: UserDefaultsCodable {

  /// Название сериала
  let name: String

  /// Описание сериала
  let description: String

  /// Изображение
  let image: Data?

  /// Ссылка на трейлер зарубежных сериалов
  var previewEngtUrl: String?
}
