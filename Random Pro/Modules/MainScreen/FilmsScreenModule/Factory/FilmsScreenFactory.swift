//
//  FilmsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol FilmsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FilmsScreenFactoryInput {
  
  /// Создать модель данных с Русскими фильмами
  /// - Parameters:
  ///  - modelsDTO: ДТО Русских фильмов
  ///  - image: Изображение
  func createRusFilmsModelFrom(_ modelsDTO: FilmsScreenRusModelDTO.Film,
                               image: Data?) -> FilmsScreenModel
  
  /// Создать модель данных с Иностранных фильмов
  /// - Parameters:
  ///  - modelsDTO: ДТО Иностранных фильмов
  ///  - image: Изображение
  func createEngFilmsModelFrom(_ modelsDTO: FilmsScreenEngModelDTO,
                               image: Data?) -> FilmsScreenModel
  
  /// Создать ссылку для Яндекс поиска
  /// - Parameter text: Текст для поиска
  func createYandexLinkWith(text: String) -> String
  
  /// Изменить ссылку на лучшее качество изображений
  func createBestQualityFrom(url: String) -> String
}

/// Фабрика
final class FilmsScreenFactory: FilmsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createBestQualityFrom(url: String) -> String {
    let lowQuality = "180x240"
    let bestQuality = "750x1000"
    let newUrl = url.replacingOccurrences(of: lowQuality, with: bestQuality)
    return newUrl
  }
  
  func createYandexLinkWith(text: String) -> String {
    let appearance = Appearance()
    let request = "\(appearance.yandexRequest + appearance.watchMovieText) \(text)"
    let formatRequest = request.replacingOccurrences(of: " ", with: "+")
    return formatRequest
  }
  
  func createRusFilmsModelFrom(_ modelsDTO: FilmsScreenRusModelDTO.Film, image: Data? = nil) -> FilmsScreenModel {
    FilmsScreenModel(name: modelsDTO.nameRu,
                     description: "\(modelsDTO.genres.first?.genre ?? "") \(modelsDTO.year)",
                     image: image)
  }
  
  func createEngFilmsModelFrom(_ modelsDTO: FilmsScreenEngModelDTO, image: Data? = nil) -> FilmsScreenModel {
    FilmsScreenModel(name: modelsDTO.title,
                     description: modelsDTO.year,
                     image: image,
                     previewEngtUrl: modelsDTO.url)
  }
}

// MARK: - Appearance

private extension FilmsScreenFactory {
  struct Appearance {
    let yandexRequest = "http://yandex.ru/search/?text="
    let watchMovieText = "смотреть фильм"
  }
}
