//
//  FilmsScreenEngModelDTO.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct FilmsScreenEngModelDTO: Codable {
  
  /// Название фильма
  let title: String
  
  /// Ссылка на трейлер
  let url: String
  
  /// Изображение
  let img: String
  
  /// Год фильма
  let year: String
}
