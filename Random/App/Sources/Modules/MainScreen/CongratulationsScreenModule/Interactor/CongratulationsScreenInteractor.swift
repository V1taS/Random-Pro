//
//  CongratulationsScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol CongratulationsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - name: Имя
  ///   - type: Тип поздравления
  func didReceive(name: String?, type: CongratulationsScreenModel.CongratulationsType)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol CongratulationsScreenInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CongratulationsScreenModel
  
  /// Получить данные
  /// - Parameter type: Тип поздравления
  func getContent(type: CongratulationsScreenModel.CongratulationsType?)
  
  /// Пользователь нажал на кнопку генерации поздравления
  func generateButtonAction()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Пол имени изменился
  /// - Parameter type: Тип поздравления
  func segmentedControlValueDidChange(type: CongratulationsScreenModel.CongratulationsType?)
  
  /// Установить новый язык
  func setNewLanguage(language: CongratulationsScreenModel.Language)
}

/// Интерактор
final class CongratulationsScreenInteractor: CongratulationsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CongratulationsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  private var casheCongratulations: [String] = []
  private var cloudKitService: ICloudKitService
  private var congratulationsScreenModel: CongratulationsScreenModel? {
    get {
      storageService.getData(from: CongratulationsScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
    cloudKitService = services.cloudKitService
  }
  
  // MARK: - Internal func
  
  func getContent(type: CongratulationsScreenModel.CongratulationsType?) {
    let newModel = CongratulationsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .birthday
    )
    let model = congratulationsScreenModel ?? newModel
    let type = type ?? (model.type ?? .birthday)
    let language = model.language ?? getDefaultLanguage()
    
    congratulationsScreenModel = CongratulationsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: type
    )
    
    checkEnvironment(type: type,
                     language: language) { [weak self] result in
      switch result {
      case let .success(listCongratulations):
        self?.casheCongratulations = listCongratulations
        self?.output?.didReceive(name: model.result, type: type)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = congratulationsScreenModel,
          let result = casheCongratulations.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    congratulationsScreenModel = CongratulationsScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      type: model.type
    )
    output?.didReceive(name: result, type: model.type ?? .birthday)
    buttonCounterService.onButtonClick()
  }
  
  func cleanButtonAction() {
    let newModel = CongratulationsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .birthday
    )
    self.congratulationsScreenModel = newModel
    output?.didReceive(name: newModel.result, type: newModel.type ?? .birthday)
    output?.cleanButtonWasSelected()
  }
  
  func segmentedControlValueDidChange(type: CongratulationsScreenModel.CongratulationsType?) {
    getContent(type: type)
  }
  
  func setNewLanguage(language: CongratulationsScreenModel.Language) {
    guard let model = congratulationsScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = CongratulationsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: model.type
    )
    congratulationsScreenModel = newModel
    getContent(type: nil)
  }
  
  func returnCurrentModel() -> CongratulationsScreenModel {
    if let model = congratulationsScreenModel {
      return model
    } else {
      return CongratulationsScreenModel(
        result: Appearance().result,
        listResult: [],
        language: getDefaultLanguage(),
        type: .birthday
      )
    }
  }
}

// MARK: - Private

private extension CongratulationsScreenInteractor {
  func fetchListNames(type: CongratulationsScreenModel.CongratulationsType,
                      language: CongratulationsScreenModel.Language,
                      completion: @escaping (Result<[String], Error>) -> Void) {
    switch language {
    case .de:
      switch type {
      case .birthday:
        fetchCongratulationsList(
          forKey: "CongratulationsBirthdayLanguageDE",
          recordTypes: .congratulationsBirthday,
          completion: completion
        )
      case .newYear:
        fetchCongratulationsList(
          forKey: "CongratulationsNewYearLanguageDE",
          recordTypes: .congratulationsNewYear,
          completion: completion
        )
      case .wedding:
        fetchCongratulationsList(
          forKey: "CongratulationsWeddingLanguageDE",
          recordTypes: .congratulationsWedding,
          completion: completion
        )
      case .anniversary:
        fetchCongratulationsList(
          forKey: "CongratulationsAnniversariesLanguageDE",
          recordTypes: .congratulationsAnniversaries,
          completion: completion
        )
      }
    case .en:
      switch type {
      case .birthday:
        fetchCongratulationsList(
          forKey: "CongratulationsBirthdayLanguageEN",
          recordTypes: .congratulationsBirthday,
          completion: completion
        )
      case .newYear:
        fetchCongratulationsList(
          forKey: "CongratulationsNewYearLanguageEN",
          recordTypes: .congratulationsNewYear,
          completion: completion
        )
      case .wedding:
        fetchCongratulationsList(
          forKey: "CongratulationsWeddingLanguageEN",
          recordTypes: .congratulationsWedding,
          completion: completion
        )
      case .anniversary:
        fetchCongratulationsList(
          forKey: "CongratulationsAnniversariesLanguageEN",
          recordTypes: .congratulationsAnniversaries,
          completion: completion
        )
      }
    case .it:
      switch type {
      case .birthday:
        fetchCongratulationsList(
          forKey: "CongratulationsBirthdayLanguageIT",
          recordTypes: .congratulationsBirthday,
          completion: completion
        )
      case .newYear:
        fetchCongratulationsList(
          forKey: "CongratulationsNewYearLanguageIT",
          recordTypes: .congratulationsNewYear,
          completion: completion
        )
      case .wedding:
        fetchCongratulationsList(
          forKey: "CongratulationsWeddingLanguageIT",
          recordTypes: .congratulationsWedding,
          completion: completion
        )
      case .anniversary:
        fetchCongratulationsList(
          forKey: "CongratulationsAnniversariesLanguageIT",
          recordTypes: .congratulationsAnniversaries,
          completion: completion
        )
      }
    case .ru:
      switch type {
      case .birthday:
        fetchCongratulationsList(
          forKey: "CongratulationsBirthdayLanguageRU",
          recordTypes: .congratulationsBirthday,
          completion: completion
        )
      case .newYear:
        fetchCongratulationsList(
          forKey: "CongratulationsNewYearLanguageRU",
          recordTypes: .congratulationsNewYear,
          completion: completion
        )
      case .wedding:
        fetchCongratulationsList(
          forKey: "CongratulationsWeddingLanguageRU",
          recordTypes: .congratulationsWedding,
          completion: completion
        )
      case .anniversary:
        fetchCongratulationsList(
          forKey: "CongratulationsAnniversariesLanguageRU",
          recordTypes: .congratulationsAnniversaries,
          completion: completion
        )
      }
    case .es:
      switch type {
      case .birthday:
        fetchCongratulationsList(
          forKey: "CongratulationsBirthdayLanguageES",
          recordTypes: .congratulationsBirthday,
          completion: completion
        )
      case .newYear:
        fetchCongratulationsList(
          forKey: "CongratulationsNewYearLanguageES",
          recordTypes: .congratulationsNewYear,
          completion: completion
        )
      case .wedding:
        fetchCongratulationsList(
          forKey: "CongratulationsWeddingLanguageES",
          recordTypes: .congratulationsWedding,
          completion: completion
        )
      case .anniversary:
        fetchCongratulationsList(
          forKey: "CongratulationsAnniversariesLanguageES",
          recordTypes: .congratulationsAnniversaries,
          completion: completion
        )
      }
    }
  }
  
  func fetchCongratulationsList(
    forKey key: String,
    recordTypes: CloudKitRecordTypes,
    completion: @escaping (Result<[String], Error>) -> Void
  ) {
    DispatchQueue.global().async { [weak self] in
      self?.getConfigurationValue(forKey: key, recordTypes: recordTypes) { (models: [String]?) -> Void in
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
  
  func getConfigurationValue<T: Codable>(
    forKey key: String,
    recordTypes: CloudKitRecordTypes,
    completion: ((T?) -> Void)?
  ) {
    let decoder = JSONDecoder()
    
    cloudKitService.getConfigurationValue(
      from: key,
      recordTypes: recordTypes
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
  
  func getDefaultLanguage() -> CongratulationsScreenModel.Language {
    let language: CongratulationsScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us
    
    switch localeType {
    case .de:
      language = .de
    case .us:
      language = .en
    case .it:
      language = .it
    case .ru:
      language = .ru
    case .es:
      language = .es
    }
    return language
  }
  
  func checkEnvironment(type: CongratulationsScreenModel.CongratulationsType,
                        language: CongratulationsScreenModel.Language,
                        completion: @escaping (Result<[String], Error>) -> Void) {
    fetchListNames(type: type, language: language, completion: completion)
  }
}

// MARK: - Appearance

private extension CongratulationsScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
