//
//  TruthOrDareScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import Foundation
import FancyNetwork
import FancyUIKit
import FancyStyle

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
  private var cloudKitService: ICloudKitService
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
    cloudKitService = services.cloudKitService
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
    
    checkEnvironment(type: typeTruthOrDare,
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
    
    switch type {
    case .truth:
      switch language {
      case .en:
        fetchTruthOrDareList(forKey: "TruthOrDare_TruthLanguageEN") { [weak self] result in
          switch result {
          case let .success(listTruthOrDare):
            completion(.success(listTruthOrDare))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .ru:
        fetchTruthOrDareList(forKey: "TruthOrDare_TruthLanguageRU") { [weak self] result in
          switch result {
          case let .success(listTruthOrDare):
            completion(.success(listTruthOrDare))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .dare:
      switch language {
      case .en:
        fetchTruthOrDareList(forKey: "TruthOrDare_DareLanguageEN") { [weak self] result in
          switch result {
          case let .success(listTruthOrDare):
            completion(.success(listTruthOrDare))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .ru:
        fetchTruthOrDareList(forKey: "TruthOrDare_DareLanguageRU") { [weak self] result in
          switch result {
          case let .success(listTruthOrDare):
            completion(.success(listTruthOrDare))
          case .failure:
            self?.output?.somethingWentWrong()
          }
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
  
  func checkEnvironment(type: TruthOrDareScreenModel.TruthOrDareType,
                        language: TruthOrDareScreenModel.Language,
                        completion: @escaping (Result<[String], Error>) -> Void) {
    fetchListTruthOrDare(type: type, language: language, completion: completion)
  }
  
  func fetchTruthOrDareList(
    forKey key: String,
    completion: @escaping (Result<[String], Error>) -> Void
  ) {
    DispatchQueue.global().async { [weak self] in
      self?.getConfigurationValue(forKey: key) { (models: [String]?) -> Void in
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

private extension TruthOrDareScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
