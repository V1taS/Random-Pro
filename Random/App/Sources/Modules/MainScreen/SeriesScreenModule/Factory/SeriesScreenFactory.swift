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

  // MARK: - Internal properties

  weak var output: SeriesScreenFactoryOutput?

  // MARK: - Internal func

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
    let appearance = Appearance()
    let request = "\(appearance.yandexRequest + appearance.watchMovieText) \(text)"
    let formatRequest = request.replacingOccurrences(of: " ", with: "+")
    return formatRequest
  }

  func createBestQualityFrom(url: String) -> String {
    let lowQuality = "180x240"
    let bestQuality = "750x1000"
    let newUrl = url.replacingOccurrences(of: lowQuality, with: bestQuality)
    return newUrl
  }
}

// MARK: - Appearance

private extension SeriesScreenFactory {
  struct Appearance {
    let yandexRequest = "http://yandex.ru/search/?text="
    let watchMovieText = "смотреть фильм"
  }
}
