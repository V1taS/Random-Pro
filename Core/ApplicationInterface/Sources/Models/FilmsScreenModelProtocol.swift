//
//  FilmsScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - FilmsScreenModelProtocol

public protocol FilmsScreenModelProtocol {
  
  /// Название фильма
  var name: String { get }
  
  /// Описание фильма
  var description: String { get }
  
  /// Изображение
  var image: Data? { get }
  
  /// Ссылка на трейлер зарубежных фильмов
  var previewEngtUrl: String? { get }
}
