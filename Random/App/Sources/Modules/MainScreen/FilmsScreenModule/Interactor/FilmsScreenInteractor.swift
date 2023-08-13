//
//  FilmsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol FilmsScreenInteractorOutput: AnyObject {
  
  /// Был получен контент с фильмами
  /// - Parameter model: Модель данных
  func didReceiveFilm(model: FilmsScreenModel)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// События которые отправляем от Presenter к Interactor
protocol FilmsScreenInteractorInput {
  
  /// Загрузить фильм
  func loadFilm()
  
  /// Сгенерировать Фильм
  func generateFilm()
  
  /// Локация Россия
  func isRuslocale() -> Bool
}

/// Интерактор
final class FilmsScreenInteractor: FilmsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let factory: FilmsScreenFactoryInput
  private let services: ApplicationServices
  private var storageService: StorageService
  private var filmsScreenModel: [FilmsScreenModel] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  ///  - factory: фабрика
  init(services: ApplicationServices,
       factory: FilmsScreenFactoryInput) {
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
  
  func generateFilm() {
    getFilmByLocale(isRussian: isRuslocale())
    services.buttonCounterService.onButtonClick()
  }
  
  func loadFilm() {
    filmsScreenModel = getFilmsData()
    
    if !filmsScreenModel.isEmpty, let filmModel = getGenerateFilms() {
      output?.didReceiveFilm(model: filmModel)
      return
    }
    
    if isRuslocale() {
      loadRusFilms {_ in }
    } else {
      loadEngFilms {_ in }
    }
  }
}

// MARK: - Private

private extension FilmsScreenInteractor {
  func loadEngFilms(completion: @escaping (_ filmsModels: [FilmsScreenModel]) -> Void) {
    output?.startLoader()
    loadListEngFilmsDto { [weak self] filmsModelsDTO in
      self?.loadImageWith(filmsDTO: filmsModelsDTO,
                          isRussian: self?.isRuslocale() ?? false) { [weak self] filmsModels in
        self?.filmsScreenModel = filmsModels
        completion(filmsModels)
        self?.output?.stopLoader()
      }
    }
  }
  
  func loadRusFilms(completion: @escaping (_ filmsModels: [FilmsScreenModel]) -> Void) {
    output?.startLoader()
    loadListRusFilmsDto { [weak self] filmsModelsDTO in
      self?.loadImageWith(filmsDTO: filmsModelsDTO,
                          isRussian: self?.isRuslocale() ?? false) { [weak self] filmsModels in
        self?.filmsScreenModel = filmsModels
        completion(filmsModels)
        self?.output?.stopLoader()
      }
    }
  }
  
  func getFilmByLocale(isRussian: Bool) {
    if !filmsScreenModel.isEmpty,
       let filmModel = getGenerateFilms() {
      output?.didReceiveFilm(model: filmModel)
    } else if isRussian {
      loadRusFilms { [weak self] filmsModels in
        guard let filmModel = filmsModels.first else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveFilm(model: filmModel)
      }
    } else {
      loadEngFilms { [weak self] filmsModels in
        guard let filmModel = filmsModels.first else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveFilm(model: filmModel)
      }
    }
  }
  
  func loadListEngFilmsDto(completion: @escaping ([FilmsScreenEngModelDTO]) -> Void) {
    let appearance = Appearance()
    
    services.networkService.performRequestWith(
      urlString: appearance.engFilmUrl,
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
          guard let model = self?.services.networkService.map(data, to: [FilmsScreenEngModelDTO].self) else {
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
  
  func loadListRusFilmsDto(completion: @escaping ([FilmsScreenRusModelDTO.Film]) -> Void) {
    let appearance = Appearance()
    let urlString = "\(appearance.rusDomenKinopoisk)\(appearance.rusEndPoint)"
    let randomFilmeType = FilmsScreenRusType.allCases.shuffled().first ?? .top250Best
    
    services.networkService.performRequestWith(
      urlString: urlString,
      queryItems: [
        URLQueryItem(name: "type",
                     value: randomFilmeType.rawvalue),
        URLQueryItem(name: "page",
                     value: "\(Int.random(in: 1...randomFilmeType.pageMaxCount))"),
        
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
          guard let model = self?.services.networkService.map(data, to: FilmsScreenRusModelDTO.self) else {
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
  
  func getGenerateFilms() -> FilmsScreenModel? {
    filmsScreenModel.shuffle()
    guard let filmModel = filmsScreenModel.first else {
      return nil
    }
    filmsScreenModel.removeFirst()
    saveFilmsData(filmsScreenModel)
    return filmModel
  }
  
  func loadImageWith(filmsDTO: [Any],
                     isRussian: Bool,
                     completion: @escaping (_ filmsModels: [FilmsScreenModel]) -> Void) {
    var filmsModels: [FilmsScreenModel] = []
    let dispatchGroup = DispatchGroup()
    filmsDTO.forEach { _ in
      dispatchGroup.enter()
    }
    
    filmsDTO.forEach { modelDTO in
      var url = ""
      
      if isRussian, let model = modelDTO as? FilmsScreenRusModelDTO.Film {
        url = model.posterUrl
      }
      
      if !isRussian, let model = modelDTO as? FilmsScreenEngModelDTO {
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
          if isRussian, let model = modelDTO as? FilmsScreenRusModelDTO.Film {
            let filmsScreenModel = self.factory.createRusFilmsModelFrom(model, image: imageData)
            filmsModels.append(filmsScreenModel)
          }
          
          if !isRussian, let model = modelDTO as? FilmsScreenEngModelDTO {
            let filmsScreenModel = self.factory.createEngFilmsModelFrom(model, image: imageData)
            filmsModels.append(filmsScreenModel)
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
      completion(filmsModels)
    }
  }
  
  func getFilmsData() -> [FilmsScreenModel] {
    return storageService.getData(from: [FilmsScreenModel].self) ?? []
  }
  
  func saveFilmsData(_ data: [FilmsScreenModel]?) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      self?.storageService.saveData(data)
    }
  }
}

// MARK: - Appearance

private extension FilmsScreenInteractor {
  struct Appearance {
    let rusDomenKinopoisk = "https://kinopoiskapiunofficial.tech"
    let rusEndPoint = "/api/v2.2/films/top"
    let rusAPIKey = SecretsAPI.apiKeyKinopoisk
    let rusHeaderAPIKey = "X-API-KEY"
    
    let engFilmUrl = "https://most-popular-movies-right-now-daily-update.p.rapidapi.com/"
    let engAPIKey = SecretsAPI.apiKeyMostPopularMovies
    let engHeaderAPIKey = "X-RapidAPI-Key"
    
    let engAPIHost = "most-popular-movies-right-now-daily-update.p.rapidapi.com"
    let engHeaderAPIHost = "X-RapidAPI-Host"
  }
}
