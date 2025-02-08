//
//  FilmsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct FilmsScreenModel: UserDefaultsCodable {
  
  /// Название фильма
  let name: String
  
  /// Описание фильма
  let description: String
  
  /// Изображение
  let image: Data?
  
  /// Ссылка на трейлер зарубежных фильмов
  var previewEngtUrl: String?
}
