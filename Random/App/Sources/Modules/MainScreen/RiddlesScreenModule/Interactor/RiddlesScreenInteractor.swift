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
  private var cloudKitService: ICloudKitService
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
    cloudKitService = services.cloudKitService
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
    switch type {
    case .easy:
      switch language {
      case .en:
        fetchRiddlesList(forKey: "RiddlesEasyLanguageEN") { [weak self] result in
          switch result {
          case let .success(listRiddles):
            completion(.success(listRiddles))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .ru:
        fetchRiddlesList(forKey: "RiddlesEasyLanguageRU") { [weak self] result in
          switch result {
          case let .success(listRiddles):
            completion(.success(listRiddles))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .hard:
      switch language {
      case .en:
        fetchRiddlesList(forKey: "RiddlesHardLanguageEN") { [weak self] result in
          switch result {
          case let .success(listRiddles):
            completion(.success(listRiddles))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .ru:
        fetchRiddlesList(forKey: "RiddlesHardLanguageRU") { [weak self] result in
          switch result {
          case let .success(listRiddles):
            completion(.success(listRiddles))
          case .failure:
            self?.output?.somethingWentWrong()
          }
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
    fetchListRiddles(type: type, language: language, completion: completion)
  }
  
  func fetchRiddlesList(
    forKey key: String,
    completion: @escaping (Result<[RiddlesScreenModel.Riddles], Error>) -> Void
  ) {
    DispatchQueue.global().async { [weak self] in
      self?.getConfigurationValue(forKey: key) { (models: [RiddlesScreenModel.Riddles]?) -> Void in
        DispatchQueue.main.async {
          if let models {
            completion(.success(models))
          } else {
            completion(.failure(NetworkError.mappingError))
          }
        }
      }
    }
  }
  
  func getConfigurationValue<T: Codable>(forKey key: String, completion: ((T?) -> Void)?) {
    let decoder = JSONDecoder()
    
    cloudKitService.getConfigurationValue(
      from: key,
      recordTypes: .backend
    ) { (result: Result<Data?, Error>) in
      switch result {
      case let .success(jsonData):
        guard let jsonData,
              let models = try? decoder.decode(T.self, from: jsonData) else {
          completion?(nil)
          return
        }
        
        completion?(models)
      case .failure:
        completion?(nil)
      }
    }
  }
}

// MARK: - Appearance

private extension RiddlesScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
