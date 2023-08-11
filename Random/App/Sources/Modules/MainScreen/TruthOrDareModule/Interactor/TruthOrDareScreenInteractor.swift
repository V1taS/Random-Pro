//
//  TruthOrDareScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import Foundation
import FancyNetwork
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol TruthOrDareScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - data: данные с правдой или действием
  ///   - type: тип генерации: правда или действие
  func didReceive(data: String?, type: TruthOrDareScreenModel.TruthOrDareType)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol TruthOrDareScreenInteractorInput {
  
  /// Получить данные
  /// - Parameter type: тип генерации: правда или действие
  func getContent(type: TruthOrDareScreenModel.TruthOrDareType?)
  
  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> TruthOrDareScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Пол имени изменился
  /// - Parameter type: тип генерации: правда или действие
  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType)
  
  /// Установить новый язык
  func setNewLanguage(language: TruthOrDareScreenModel.Language)
}

/// Интерактор
final class TruthOrDareScreenInteractor: TruthOrDareScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private var casheTruthOrDare: [String] = []
  private let buttonCounterService: ButtonCounterService
  private var truthOrDareScreenModel: TruthOrDareScreenModel? {
    get {
      storageService.getData(from: TruthOrDareScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent(type: TruthOrDareScreenModel.TruthOrDareType?) {
    let newModel = TruthOrDareScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .truth
    )
    let model = truthOrDareScreenModel ?? newModel
    let typeTruthOrDare = type ?? (model.type ?? .truth)
    let language = model.language ?? getDefaultLanguage()
    
    truthOrDareScreenModel = TruthOrDareScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: typeTruthOrDare
    )
    
    fetchListTruthOrDare(type: typeTruthOrDare,
                         language: language) { [weak self] result in
      switch result {
      case let .success(listTruthOrDare):
        self?.casheTruthOrDare = listTruthOrDare
        self?.output?.didReceive(data: model.result, type: typeTruthOrDare)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = truthOrDareScreenModel,
          let result = casheTruthOrDare.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    truthOrDareScreenModel = TruthOrDareScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      type: model.type
    )
    output?.didReceive(data: result, type: model.type ?? .truth)
    buttonCounterService.onButtonClick()
  }
  
  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType) {
    getContent(type: type)
  }
  
  func setNewLanguage(language: TruthOrDareScreenModel.Language) {
    guard let model = truthOrDareScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = TruthOrDareScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: model.type
    )
    truthOrDareScreenModel = newModel
    getContent(type: nil)
  }
  
  func returnCurrentModel() -> TruthOrDareScreenModel {
    if let model = truthOrDareScreenModel {
      return model
    } else {
      return TruthOrDareScreenModel(
        result: Appearance().result,
        listResult: [],
        language: getDefaultLanguage(),
        type: .truth
      )
    }
  }
  
  func cleanButtonAction() {
    let newModel = TruthOrDareScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .truth
    )
    self.truthOrDareScreenModel = newModel
    output?.didReceive(data: newModel.result, type: newModel.type ?? .truth)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension TruthOrDareScreenInteractor {
  func fetchListTruthOrDare(type: TruthOrDareScreenModel.TruthOrDareType,
                            language: TruthOrDareScreenModel.Language,
                            completion: @escaping (Result<[String], Error>) -> Void) {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "type", value: type.rawValue),
        .init(name: "language", value: language.rawValue)
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]
    ) { [weak self] result in
      guard let self else {
        return
      }
      DispatchQueue.main.async {
        
        switch result {
        case let .success(data):
          guard let listTruthOrDare = self.networkService.map(data, to: [String].self) else {
            completion(.failure(NetworkError.mappingError))
            return
          }
          completion(.success(listTruthOrDare))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }
  }
  
  func getDefaultLanguage() -> TruthOrDareScreenModel.Language {
    let language: TruthOrDareScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us
    
    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
}

// MARK: - Appearance

private extension TruthOrDareScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/truthOrDare"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
