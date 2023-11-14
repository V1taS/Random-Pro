//
//  SeriesScreenEngModelDTO.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SeriesScreenEngModelDTO: Codable {

  /// Название сериала
  let title: String

  /// Ссылка на трейлер
  let url: String

  /// Изображение
  let img: String

  /// Год сериала
  let year: String
}
