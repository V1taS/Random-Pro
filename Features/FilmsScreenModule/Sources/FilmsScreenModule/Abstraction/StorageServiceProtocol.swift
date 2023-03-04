//
//  StorageServiceProtocol.swift
//  FilmsScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для фильмов
  var filmsScreenModel: [FilmsScreenModelProtocol]? { get set }
}

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
