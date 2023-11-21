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

  func loadListEngSeriesDTO(completion: @escaping ([SeriesScreenEngModelDTO.Series]) -> Void) {
    let appearance = Appearance()
    let urlString = "\(appearance.domenKinopoisk)\(appearance.endPoint)"
    let randomSeriesType = SeriesScreenType.allCases.shuffled().first ?? .tvSeries

    services.networkService.performRequestWith(
      urlString: urlString,
      queryItems: [
        URLQueryItem(name: "countries",
                     value: "1"),
        URLQueryItem(name: "type",
                     value: randomSeriesType.rawvalue),
        URLQueryItem(name: "ratingFrom",
                     value: appearance.minRating),
        URLQueryItem(name: "page",
                     value: "\(Int.random(in: 1...randomSeriesType.pageMaxCount))"),
      ],
      httpMethod: .get,
      headers: [
        .additionalHeaders(set: [
          (key: appearance.headerAPIKey, value: appearance.APIKey)
        ]),
        .contentTypeJson
      ]
    ) { [weak self] result in
      switch result {
      case let .success(data):
        DispatchQueue.main.async {
          guard let model = self?.services.networkService.map(data, to: SeriesScreenEngModelDTO.self) else {
            self?.output?.somethingWentWrong()
            return
          }
          completion(model.items)
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
    let urlString = "\(appearance.domenKinopoisk)\(appearance.endPoint)"
    let randomSeriesType = SeriesScreenType.allCases.shuffled().first ?? .tvSeries

    services.networkService.performRequestWith(
      urlString: urlString,
      queryItems: [
        URLQueryItem(name: "type",
                     value: randomSeriesType.rawvalue),
        URLQueryItem(name: "ratingFrom",
                     value: appearance.minRating),
        URLQueryItem(name: "page",
                     value: "\(Int.random(in: 1...randomSeriesType.pageMaxCount))"),
      ],
      httpMethod: .get,
      headers: [
        .additionalHeaders(set: [
          (key: appearance.headerAPIKey, value: appearance.APIKey)
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
          completion(model.items)
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

      if !isRussian, let model = modelDTO as? SeriesScreenEngModelDTO.Series {
        url = model.posterUrl
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

          if !isRussian, let model = modelDTO as? SeriesScreenEngModelDTO.Series {
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
    let domenKinopoisk = "https://kinopoiskapiunofficial.tech"
    let APIKey = SecretsAPI.apiKeyKinopoisk
    let headerAPIKey = "X-API-KEY"
    let endPoint = "/api/v2.2/films"

    let minRating = "4"




 //   let engSeriesUrl = "https://kinopoiskapiunofficial.tech"
    //let engAPIKey = SecretsAPI.apiKeyMostPopularMovies
  //  let engHeaderAPIKey = "X-RapidAPI-Key"

 //   let engAPIHost = "most-popular-movies-right-now-daily-update.p.rapidapi.com"
   // let engHeaderAPIHost = "X-RapidAPI-Host"
  }
}
