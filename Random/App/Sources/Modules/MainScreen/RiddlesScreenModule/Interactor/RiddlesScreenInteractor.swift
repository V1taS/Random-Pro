//
//  RiddlesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol RiddlesScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - name: Имя
  ///   - type: Тип сложности
  func didReceive(riddles: RiddlesScreenModel.Riddles,
                  type: RiddlesScreenModel.DifficultType)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol RiddlesScreenInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> RiddlesScreenModel
  
  /// Получить данные
  /// - Parameter type: Тип сложности
  func getContent(type: RiddlesScreenModel.DifficultType?)
  
  /// Пользователь нажал на кнопку генерации поздравления
  func generateButtonAction()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: RiddlesScreenModel.Language)
  
  /// Пол имени изменился
  /// - Parameter type: Тип сложности
  func segmentedControlValueDidChange(type: RiddlesScreenModel.DifficultType?)
}

/// Интерактор
final class RiddlesScreenInteractor: RiddlesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: RiddlesScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private var buttonCounterService: ButtonCounterService
  private var casheRiddles: [RiddlesScreenModel.Riddles] = []
  private var riddlesScreenModel: RiddlesScreenModel? {
    get {
      storageService.getData(from: RiddlesScreenModel.self)
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
  
  func getContent(type: RiddlesScreenModel.DifficultType?) {
    let newModel = RiddlesScreenModel(
      result: .init(question: Appearance().result,
                    answer: Appearance().result),
      listResult: [],
      language: getDefaultLanguage(),
      type: .easy
    )
    let model = riddlesScreenModel ?? newModel
    let type = type ?? model.type
    let language = model.language ?? getDefaultLanguage()
    
    riddlesScreenModel = RiddlesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: type
    )
    
    checkEnvironment(type: type,
                     language: language) { [weak self] result in
      switch result {
      case let .success(listCongratulations):
        self?.casheRiddles = listCongratulations
        self?.output?.didReceive(riddles: model.result, type: type)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = riddlesScreenModel,
          let result = casheRiddles.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    riddlesScreenModel = RiddlesScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      type: model.type
    )
    output?.didReceive(riddles: result, type: model.type)
    buttonCounterService.onButtonClick()
  }
  
  func cleanButtonAction() {
    let newModel = RiddlesScreenModel(
      result: .init(question: Appearance().result,
                    answer: Appearance().result),
      listResult: [],
      language: getDefaultLanguage(),
      type: .easy
    )
    self.riddlesScreenModel = newModel
    output?.didReceive(riddles: newModel.result,
                       type: newModel.type)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: RiddlesScreenModel.Language) {
    guard let model = riddlesScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = RiddlesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: model.type
    )
    riddlesScreenModel = newModel
    getContent(type: nil)
  }
  
  func segmentedControlValueDidChange(type: RiddlesScreenModel.DifficultType?) {
    getContent(type: type)
  }
  
  func returnCurrentModel() -> RiddlesScreenModel {
    if let model = riddlesScreenModel {
      return model
    } else {
      return RiddlesScreenModel(
        result: .init(question: Appearance().result,
                      answer: Appearance().result),
        listResult: [],
        language: getDefaultLanguage(),
        type: .easy
      )
    }
  }
}

// MARK: - Private

private extension RiddlesScreenInteractor {
  func fetchListRiddles(type: RiddlesScreenModel.DifficultType,
                        language: RiddlesScreenModel.Language,
                        completion: @escaping (Result<[RiddlesScreenModel.Riddles], Error>) -> Void) {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "difficult", value: type.rawValue),
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
          guard let listRiddles = self.networkService.map(data, to: [RiddlesScreenModel.Riddles].self) else {
            completion(.failure(NetworkError.mappingError))
            return
          }
          completion(.success(listRiddles))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }
  }
  
  func getDefaultLanguage() -> RiddlesScreenModel.Language {
    let language: RiddlesScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us
    
    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
  
  func checkEnvironment(type: RiddlesScreenModel.DifficultType,
                        language: RiddlesScreenModel.Language,
                        completion: @escaping (Result<[RiddlesScreenModel.Riddles], Error>) -> Void) {
#if DEBUG
    let mockData: [RiddlesScreenModel.Riddles] = [
      .init(question: "Без рук, без ног, а рисовать умеет.",
            answer: "Мороз"),
      .init(question: "Домашнее животное, на ы начинается",
            answer: "Ыщо один таракан"),
      .init(question: "Когда 2 и 2 бывают больше четырёх?",
            answer: "Когда 22"),
    ]
    completion(.success(mockData))
#else
    fetchListRiddles(type: type, language: language, completion: completion)
#endif
  }
}

// MARK: - Appearance

private extension RiddlesScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/riddles"
    let apiKey = "api_key"
    let apiValue = SecretsAPI.fancyBackend
  }
}
