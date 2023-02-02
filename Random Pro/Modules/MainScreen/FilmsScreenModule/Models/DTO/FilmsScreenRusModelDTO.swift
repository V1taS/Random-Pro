//
//  FilmsScreenRusModelDTO.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 31.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct FilmsScreenRusModelDTO: Codable {
  
  /// Список фильмов
  let films: [Film]
  
  // MARK: - Film
  
  struct Film: Codable {
    
    /// Название фильма
    let nameRu: String
    
    /// Жанры фильма
    let genres: [Genre]
    
    /// Год выпуска фильма
    let year: String
    
    /// URL Картинки
    let posterUrl: String
  }
  
  // MARK: - Genre
  
  struct Genre: Codable {
    
    /// Жанр фильма
    let genre: String
  }
}
