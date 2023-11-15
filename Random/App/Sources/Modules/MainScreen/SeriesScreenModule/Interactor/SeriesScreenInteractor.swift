//
//  SeriesScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol SeriesScreenInteractorOutput: AnyObject {

  /// Был получен контент с сериалами
  /// - Parameter model: Модель данных
  func didReceiveSeries(model: SeriesScreenModel)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Запустить лоадер
  func startLoader()

  /// Остановить лоадер
  func stopLoader()
}

/// События которые отправляем от Presenter к Interactor
protocol SeriesScreenInteractorInput {

  /// Загрузить сериал
  func loadSeries()

  /// Сгенерировать сериал
  func generateSeries()

  /// Локация Россия
  func isRuslocale() -> Bool
}

/// Интерактор
final class SeriesScreenInteractor: SeriesScreenInteractorInput {

  // MARK: - Internal properties
  
  weak var output: SeriesScreenInteractorOutput?

  // MARK: - Private property

  private let factory: SeriesScreenFactoryInput
  private let services: ApplicationServices
  private var storageService: StorageService
  private var seriesScreenModel: [SeriesScreenModel] = []

  // MARK: - Initialization

  /// - Parameters:
  ///  - services: Сервисы приложения
  ///  - factory: фабрика
  init(services: ApplicationServices,
       factory: SeriesScreenFactoryInput) {
    self.services = services
    self.factory = factory
    storageService = services.storageService
  }
  
  // MARK: - Internal func

  func isRuslocale() -> Bool {
    guard let localeType = CountryType.getCurrentCountryType() else {
      return false
    }

    switch localeType {
    case .ru:
      return true
    default:
      return false
    }
  }

  func generateSeries() {
    getSeriesByLocale(isRussian: isRuslocale())
    services.buttonCounterService.onButtonClick()
  }

  func loadSeries() {
    seriesScreenModel = getSeriesData()

    if !seriesScreenModel.isEmpty, let seriesModel = getGenerateSeries() {
      output?.didReceiveSeries(model: seriesModel)
      return
    }
    if isRuslocale() {
      loadRusSeries { _ in }
    } else {
      loadEngSeries { _ in }
    }
  }
}

// MARK: - Private

private extension SeriesScreenInteractor {

  func loadEngSeries(completion: @escaping (_ seriesModels: [SeriesScreenModel]) -> Void) {
    output?.startLoader()
    loadListEngSeriesDTO { [weak self] seriesModelsDTO in
      self?.loadImageWith(seriesDTO: seriesModelsDTO,
                          isRussian: self?.isRuslocale() ?? false) { [weak self] seriesModels in
        self?.seriesScreenModel = seriesModels
        completion(seriesModels)
        self?.output?.stopLoader()
      }
    }
  }

  func loadRusSeries(completion: @escaping (_ seriesModels: [SeriesScreenModel]) -> Void) {
    output?.startLoader()
    loadListRusSeriesDTO { [weak self] seriesModelsDTO in
      self?.loadImageWith(seriesDTO: seriesModelsDTO,
                          isRussian: self?.isRuslocale() ?? false) { [weak self] seriesModels in
        self?.seriesScreenModel = seriesModels
        completion(seriesModels)
        self?.output?.stopLoader()
      }
    }
  }

  func getSeriesByLocale(isRussian: Bool) {
    if !seriesScreenModel.isEmpty,
       let seriesModel = getGenerateSeries() {
      output?.didReceiveSeries(model: seriesModel)
    } else if isRussian {
      loadRusSeries { [weak self] seriesModels in
        guard let seriesModel = seriesModels.first else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveSeries(model: seriesModel)
      }
    } else {
      loadEngSeries { [weak self] seriesModels in
        guard let seriesModel = seriesModels.first else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveSeries(model: seriesModel)
      }
    }
  }

  func loadListEngSeriesDTO(completion: @escaping ([SeriesScreenEngModelDTO]) -> Void) {
    let appearance = Appearance()

    services.networkService.performRequestWith(
      urlString: appearance.engSeriesUrl,
      queryItems: [],
      httpMethod: .get,
      headers: [
        .additionalHeaders(set: [
          (key: appearance.engHeaderAPIKey, value: appearance.engAPIKey),
          (key: appearance.engHeaderAPIHost, value: appearance.engAPIHost)
        ]),
        .contentTypeJson
      ]
    ) { [weak self] result in
      switch result {
      case let .success(data):
        DispatchQueue.main.async {
          guard let model = self?.services.networkService.map(data, to: [SeriesScreenEngModelDTO].self) else {
            self?.output?.somethingWentWrong()
            return
          }
          completion(model)
        }
      case .failure:
        DispatchQueue.main.async {
          completion([])
          self?.output?.somethingWentWrong()
        }
      }
    }
  }

  func loadListRusSeriesDTO(completion: @escaping ([SeriesScreenRusModelDTO.Series]) -> Void) {
    let appearance = Appearance()
    let urlString = "\(appearance.rusDomenKinopoisk)\(appearance.rusEndPoint)"
    let randomSeriesType = SeriesScreenRusType.allCases.shuffled().first ?? .top250Best

    services.networkService.performRequestWith(
      urlString: urlString,
      queryItems: [
        URLQueryItem(name: "type",
                     value: randomSeriesType.rawvalue),
        URLQueryItem(name: "page",
                     value: "\(Int.random(in: 1...randomSeriesType.pageMaxCount))"),

      ],
      httpMethod: .get,
      headers: [
        .additionalHeaders(set: [
          (key: appearance.rusHeaderAPIKey, value: appearance.rusAPIKey)
        ]),
        .contentTypeJson
      ]
    ) { [weak self] result in
      switch result {
      case let .success(data):
        DispatchQueue.main.async {
          guard let model = self?.services.networkService.map(data, to: SeriesScreenRusModelDTO.self) else {
            self?.output?.somethingWentWrong()
            return
          }
          completion(model.films)
        }
      case .failure:
        DispatchQueue.main.async {
          completion([])
          self?.output?.somethingWentWrong()
        }
      }
    }
  }

  func loadImageWith(seriesDTO: [Any],
                     isRussian: Bool,
                     completion: @escaping (_ seriesModels: [SeriesScreenModel]) -> Void) {
    var seriesModels: [SeriesScreenModel] = []
    let dispatchGroup = DispatchGroup()
    seriesDTO.forEach { _ in
      dispatchGroup.enter()
    }

    seriesDTO.forEach { modelDTO in
      var url = ""

      if isRussian, let model = modelDTO as? SeriesScreenRusModelDTO.Series {
        url = model.posterUrl
      }

      if !isRussian, let model = modelDTO as? SeriesScreenEngModelDTO {
        url = factory.createBestQualityFrom(url: model.img)
      }

      services.networkService.performRequestWith(urlString: url,
                                                 queryItems: [],
                                                 httpMethod: .get,
                                                 headers: []) { [weak self] result in
        guard let self = self else {
          return
        }
        switch result {
        case let .success(imageData):
          if isRussian, let model = modelDTO as? SeriesScreenRusModelDTO.Series {
            let seriesScreenModel = self.factory.createRusSeriesModelFrom(model, image: imageData)
            seriesModels.append(seriesScreenModel)
          }

          if !isRussian, let model = modelDTO as? SeriesScreenEngModelDTO {
            let seriesScreenModel = self.factory.createEngSeriesModelFrom(model, image: imageData)
            seriesModels.append(seriesScreenModel)
          }
          dispatchGroup.leave()
        case .failure:
          dispatchGroup.leave()
          DispatchQueue.main.async {
            self.output?.somethingWentWrong()
          }
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion(seriesModels)
    }
  }

  func getGenerateSeries() -> SeriesScreenModel? {
    seriesScreenModel.shuffle()
    guard let seriesModel = seriesScreenModel.first else {
      return nil
    }
    seriesScreenModel.removeFirst()
    saveSeriesData(seriesScreenModel)
    return seriesModel
  }

  func getSeriesData() -> [SeriesScreenModel] {
    return storageService.getData(from: [SeriesScreenModel].self) ?? []
  }

  func saveSeriesData(_ data: [SeriesScreenModel]?) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      self?.storageService.saveData(data)
    }
  }

}

// MARK: - Appearance

private extension SeriesScreenInteractor {
  struct Appearance {
    let rusDomenKinopoisk = "https://kinopoiskapiunofficial.tech"
    let rusEndPoint = "/api/v2.2/films/top"
    let rusAPIKey = SecretsAPI.apiKeyKinopoisk
    let rusHeaderAPIKey = "X-API-KEY"

    let engSeriesUrl = "https://most-popular-movies-right-now-daily-update.p.rapidapi.com/"
    let engAPIKey = SecretsAPI.apiKeyMostPopularMovies
    let engHeaderAPIKey = "X-RapidAPI-Key"

    let engAPIHost = "most-popular-movies-right-now-daily-update.p.rapidapi.com"
    let engHeaderAPIHost = "X-RapidAPI-Host"
  }
}
