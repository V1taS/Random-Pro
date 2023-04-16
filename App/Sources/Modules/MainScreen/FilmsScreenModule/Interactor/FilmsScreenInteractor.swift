//
//  FilmsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit
import RandomNetwork

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
  private var filmsScreenModel: [FilmsScreenModel] = [] {
    didSet {
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        self?.storageService.filmsScreenModel = self?.filmsScreenModel
      }
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  ///  - factory: фабрика
  init(services: ApplicationServices,
       factory: FilmsScreenFactoryInput) {
    self.services = services
    self.factory = factory
    storageService = services.storageService
    filmsScreenModel = services.storageService.filmsScreenModel ?? []
  }
  
  // MARK: - Internal func
  
  func isRuslocale() -> Bool {
    let appearance = Appearance()
    let locale = Locale.current
    if locale.regionCode == appearance.rusRegionCode {
      return true
    } else {
      return false
    }
  }
  
  func generateFilm() {
    if isRuslocale() {
      getRusFilms()
    } else {
      getEngFilms()
    }
  }
  
  func loadFilm() {
    if isRuslocale() {
      if services.storageService.filmsScreenModel == nil {
        loadRusFilms {}
      }
    } else {
      if services.storageService.filmsScreenModel == nil {
        loadEngFilms {}
      }
    }
  }
}

// MARK: - Private

private extension FilmsScreenInteractor {
  func loadEngFilms(completion: @escaping () -> Void) {
    output?.startLoader()
    loadListEngFilmsDto { [weak self] filmsModelsDTO in
      self?.loadEngImageWith(filmsEngDTO: filmsModelsDTO) { [weak self] filmsModels in
        self?.filmsScreenModel = filmsModels
        completion()
        self?.output?.stopLoader()
      }
    }
  }
  
  func loadRusFilms(completion: @escaping () -> Void) {
    output?.startLoader()
    loadListRusFilmsDto { [weak self] filmsModelsDTO in
      self?.loadRusImageWith(filmsRusDTO: filmsModelsDTO) { [weak self] filmsModels in
        self?.filmsScreenModel = filmsModels
        completion()
        self?.output?.stopLoader()
      }
    }
  }
  
  func getEngFilms() {
    if filmsScreenModel.isEmpty {
      loadEngFilms { [weak self] in
        guard let filmModel = self?.getGenerateRusFilms() else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveFilm(model: filmModel)
      }
    } else {
      guard let filmModel = getGenerateRusFilms() else {
        output?.somethingWentWrong()
        return
      }
      output?.didReceiveFilm(model: filmModel)
    }
  }
  
  func getRusFilms() {
    if filmsScreenModel.isEmpty {
      loadRusFilms { [weak self] in
        guard let filmModel = self?.getGenerateRusFilms() else {
          self?.output?.somethingWentWrong()
          return
        }
        self?.output?.didReceiveFilm(model: filmModel)
      }
    } else {
      guard let filmModel = getGenerateRusFilms() else {
        output?.somethingWentWrong()
        return
      }
      output?.didReceiveFilm(model: filmModel)
    }
  }
  
  func loadListEngFilmsDto(completion: @escaping ([FilmsScreenEngModelDTO]) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      let appearance = Appearance()
      let headers: [String: String] = [
        appearance.engAPIKey: appearance.engHeaderAPIKey,
        appearance.engAPIHost: appearance.engHeaderAPIHost
      ]
      self?.services.networkService.performRequestWith(
        urlString: appearance.engFilmUrl,
        queryItems: [],
        httpMethod: .get,
        headers: [
          .additionalHeaders(setValue: headers),
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
  }
  
  func loadListRusFilmsDto(completion: @escaping ([FilmsScreenRusModelDTO.Film]) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      let appearance = Appearance()
      let urlString = "\(appearance.rusDomenKinopoisk)\(appearance.rusEndPoint)"
      let headers: [String: String] = [
        appearance.rusAPIKey: appearance.rusHeaderAPIKey
      ]
      let randomFilmeType = FilmsScreenRusType.allCases.shuffled().first ?? .top250Best
      self?.services.networkService.performRequestWith(
        urlString: urlString,
        queryItems: [
          URLQueryItem(name: "type",
                       value: randomFilmeType.rawvalue),
          URLQueryItem(name: "page",
                       value: "\(Int.random(in: 1...randomFilmeType.pageMaxCount))"),
          
        ],
        httpMethod: .get,
        headers: [
          .additionalHeaders(setValue: headers),
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
  }
  
  func getGenerateRusFilms() -> FilmsScreenModel? {
    filmsScreenModel.shuffle()
    guard let filmModel = filmsScreenModel.first else {
      return nil
    }
    filmsScreenModel.removeFirst()
    return filmModel
  }
  
  func loadEngImageWith(filmsEngDTO: [FilmsScreenEngModelDTO],
                        completion: @escaping (_ filmsModels: [FilmsScreenModel]) -> Void) {
    var filmsModels: [FilmsScreenModel] = []
    let dispatchGroup = DispatchGroup()
    filmsEngDTO.forEach { _ in
      dispatchGroup.enter()
    }
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        return
      }
      filmsEngDTO.forEach { modelDTO in
        self.services.networkService.performRequestWith(urlString: self.factory.createBestQualityFrom(url: modelDTO.img),
                                                        queryItems: [],
                                                        httpMethod: .get,
                                                        headers: []) { [weak self] result in
          guard let self else {
            return
          }
          switch result {
          case let .success(imageData):
            let model = self.factory.createEngFilmsModelFrom(modelDTO,
                                                             image: imageData)
            filmsModels.append(model)
            dispatchGroup.leave()
          case .failure:
            dispatchGroup.leave()
            self.output?.somethingWentWrong()
          }
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion(filmsModels)
    }
  }
  
  func loadRusImageWith(filmsRusDTO: [FilmsScreenRusModelDTO.Film],
                        completion: @escaping (_ filmsModels: [FilmsScreenModel]) -> Void) {
    var filmsModels: [FilmsScreenModel] = []
    let dispatchGroup = DispatchGroup()
    filmsRusDTO.forEach { _ in
      dispatchGroup.enter()
    }
    
    DispatchQueue.global(qos: .userInteractive).async {
      filmsRusDTO.forEach { modelDTO in
        self.services.networkService.performRequestWith(urlString: modelDTO.posterUrl,
                                                        queryItems: [],
                                                        httpMethod: .get,
                                                        headers: []) { [weak self] result in
          guard let self else {
            return
          }
          switch result {
          case let .success(imageData):
            let model = self.factory.createRusFilmsModelFrom(modelDTO,
                                                             image: imageData)
            filmsModels.append(model)
            dispatchGroup.leave()
          case .failure:
            dispatchGroup.leave()
            self.output?.somethingWentWrong()
          }
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion(filmsModels)
    }
  }
}

// MARK: - Appearance

private extension FilmsScreenInteractor {
  struct Appearance {
    let rusDomenKinopoisk = "https://kinopoiskapiunofficial.tech"
    let rusEndPoint = "/api/v2.2/films/top"
    let rusAPIKey = "f835989c-b489-4624-9209-6d93bfead535"
    let rusHeaderAPIKey = "X-API-KEY"
    let rusRegionCode = "RU"
    
    let engFilmUrl = "https://most-popular-movies-right-now-daily-update.p.rapidapi.com/"
    let engAPIKey = "f7321a82d8msh8cd3d6fb5db3824p1bef63jsn40adb1a66d30"
    let engHeaderAPIKey = "X-RapidAPI-Key"
    
    let engAPIHost = "most-popular-movies-right-now-daily-update.p.rapidapi.com"
    let engHeaderAPIHost = "X-RapidAPI-Host"
  }
}
