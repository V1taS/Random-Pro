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

  /// Создать ссылку для Google поиска
  /// - Parameter text: Текст для поиска
  func createGoogleLinkWith(text: String) -> String
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
    let date = formatDate(from: modelsDTO.premiered ?? "")
    return  SeriesScreenModel(name: modelsDTO.name ?? "",
                              description: "\(modelsDTO.genres?.first ?? "") \(String(describing: date))",
                              image: image)
  }

  func createYandexLinkWith(text: String) -> String {
    let appearance = Appearance()
    let request = "\(appearance.yandexRequest + appearance.watchRusTrailerText) \(text)"
    let formatRequest = request.replacingOccurrences(of: " ", with: "+")
    return formatRequest
  }

  func createGoogleLinkWith(text: String) -> String {
    let appearance = Appearance()
    let request = "\(appearance.googleRequest + appearance.watchEngTrailerText) \(text)"
    let formatRequest = request.replacingOccurrences(of: " ", with: "+")
    return formatRequest
  }
}

// MARK: - Private

private extension SeriesScreenFactory {
  func formatDate(from date: String) -> String {
    let formattorToDate = DateFormatter()
    formattorToDate.dateFormat = "yyyy-MM-dd"

    guard let date = formattorToDate.date(from: date) else {
      return ""
    }

    let formattorToString = DateFormatter()
    formattorToString.dateFormat = "yyyy"
    let newStringDate = formattorToString.string(from: date)
    return newStringDate
  }
}

// MARK: - Appearance

private extension SeriesScreenFactory {
  struct Appearance {
    let yandexRequest = "http://yandex.ru/search/?text="
    let watchRusTrailerText = "смотреть трейлер"

    let googleRequest = "https://www.google.com/search?q="
    let watchEngTrailerText = "watch trailer"
  }
}
