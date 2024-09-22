//
//  NamesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol NamesScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - name: Имя
  ///   - gender: Пол имени
  func didReceive(name: String?, gender: NamesScreenModel.Gender)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol NamesScreenInteractorInput {
  
  /// Получить данные
  /// - Parameter gender: Пол для имени
  func getContent(gender: NamesScreenModel.Gender?)
  
  /// Пользователь нажал на кнопку генерации женского имени
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> NamesScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Пол имени изменился
  /// - Parameter type: Пол имени
  func segmentedControlValueDidChange(type: NamesScreenModel.Gender)
  
  /// Установить новый язык
  func setNewLanguage(language: NamesScreenModel.Language)
}

/// Интерактор
final class NamesScreenInteractor: NamesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: NamesScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var cloudKitService: ICloudKitService
  private var casheNames: [String] = []
  private let buttonCounterService: ButtonCounterService
  private var namesScreenModel: NamesScreenModel? {
    get {
      storageService.getData(from: NamesScreenModel.self)
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
  
  func getContent(gender: NamesScreenModel.Gender?) {
    let newModel = NamesScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      gender: .male
    )
    let model = namesScreenModel ?? newModel
    let gender = gender ?? (model.gender ?? .male)
    let language = model.language ?? getDefaultLanguage()
    
    namesScreenModel = NamesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: gender
    )
    
    checkEnvironment(gender: gender,
                     language: language) { [weak self] result in
      switch result {
      case let .success(listNames):
        self?.casheNames = listNames
        self?.output?.didReceive(name: model.result, gender: gender)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = namesScreenModel,
          let result = casheNames.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    namesScreenModel = NamesScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      gender: model.gender
    )
    output?.didReceive(name: result, gender: model.gender ?? .male)
    buttonCounterService.onButtonClick()
  }
  
  func segmentedControlValueDidChange(type: NamesScreenModel.Gender) {
    getContent(gender: type)
  }
  
  func setNewLanguage(language: NamesScreenModel.Language) {
    guard let model = namesScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = NamesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: model.gender
    )
    namesScreenModel = newModel
    getContent(gender: nil)
  }
  
  func returnCurrentModel() -> NamesScreenModel {
    if let model = namesScreenModel {
      return model
    } else {
      return NamesScreenModel(
        result: Appearance().result,
        listResult: [],
        language: getDefaultLanguage(),
        gender: .male
      )
    }
  }
  
  func cleanButtonAction() {
    let newModel = NamesScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      gender: .male
    )
    self.namesScreenModel = newModel
    output?.didReceive(name: newModel.result, gender: newModel.gender ?? .male)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension NamesScreenInteractor {
  func fetchListNames(gender: NamesScreenModel.Gender,
                      language: NamesScreenModel.Language,
                      completion: @escaping (Result<[String], Error>) -> Void) {
    switch language {
    case .de:
      switch gender {
      case .male:
        fetchNamesList(forKey: "NamesMaleLanguageDE", recordTypes: .namesMale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .female:
        fetchNamesList(forKey: "NamesFemaleLanguageDE", recordTypes: .namesFemale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .en:
      switch gender {
      case .male:
        fetchNamesList(forKey: "NamesMaleLanguageEN", recordTypes: .namesMale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .female:
        fetchNamesList(forKey: "NamesFemaleLanguageEN", recordTypes: .namesFemale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .it:
      switch gender {
      case .male:
        fetchNamesList(forKey: "NamesMaleLanguageIT", recordTypes: .namesMale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .female:
        fetchNamesList(forKey: "NamesFemaleLanguageIT", recordTypes: .namesFemale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .ru:
      switch gender {
      case .male:
        fetchNamesList(forKey: "NamesMaleLanguageRU", recordTypes: .namesMale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .female:
        fetchNamesList(forKey: "NamesFemaleLanguageRU", recordTypes: .namesFemale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    case .es:
      switch gender {
      case .male:
        fetchNamesList(forKey: "NamesMaleLanguageES", recordTypes: .namesMale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      case .female:
        fetchNamesList(forKey: "NamesFemaleLanguageES", recordTypes: .namesFemale) { [weak self] result in
          switch result {
          case let .success(listNames):
            completion(.success(listNames))
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
    }
  }
  
  func getDefaultLanguage() -> NamesScreenModel.Language {
    let language: NamesScreenModel.Language
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
  
  func checkEnvironment(gender: NamesScreenModel.Gender,
                        language: NamesScreenModel.Language,
                        completion: @escaping (Result<[String], Error>) -> Void) {
    fetchListNames(gender: gender, language: language, completion: completion)
  }
  
  func fetchNamesList(
    forKey key: String,
    recordTypes: CloudKitService.RecordTypes,
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
    recordTypes: CloudKitService.RecordTypes,
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
}

// MARK: - Appearance

private extension NamesScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
