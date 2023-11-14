//
//  SeriesScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol SeriesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol SeriesScreenFactoryInput {

  /// Создать модель данных с Русскими сериалами
  /// - Parameters:
  ///  - modelsDTO: ДТО Русских сериалов
  ///  - image: Изображение
  func createRusSeriesModelFrom(_ modelsDTO: SeriesScreenRusModelDTO.Series,
                                image: Data?) -> SeriesScreenModel

  /// Создать модель данных с Иностранных сериалов
  /// - Parameters:
  ///  - modelsDTO: ДТО Иностранных сериалов
  ///  - image: Изображение
  func createEngSeriesModelFrom(_ modelsDTO: SeriesScreenEngModelDTO,
                                image: Data?) -> SeriesScreenModel

  /// Создать ссылку для Яндекс поиска
  /// - Parameter text: Текст для поиска
  func createYandexLinkWith(text: String) -> String

  /// Изменить ссылку на лучшее качество изображений
  func createBestQualityFrom(url: String) -> String
}

/// Фабрика
final class SeriesScreenFactory: SeriesScreenFactoryInput {
  func createRusSeriesModelFrom(_ modelsDTO: SeriesScreenRusModelDTO.Series, image: Data?) -> SeriesScreenModel {
    SeriesScreenModel(name: modelsDTO.nameRu,
                      description: "\(modelsDTO.genres.first?.genre ?? "") \(modelsDTO.year)",
                      image: image)
  }

  func createEngSeriesModelFrom(_ modelsDTO: SeriesScreenEngModelDTO, image: Data?) -> SeriesScreenModel {
    SeriesScreenModel(name: modelsDTO.title,
                      description: modelsDTO.year,
                      image: image,
                      previewEngtUrl: modelsDTO.url)
  }

  func createYandexLinkWith(text: String) -> String {
    "mock"
  }

  func createBestQualityFrom(url: String) -> String {
    "mock"
  }
  
  // MARK: - Internal properties
  
  weak var output: SeriesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension SeriesScreenFactory {
  struct Appearance {}
}
