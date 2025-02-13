//
//  JokeGeneratorScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import FancyNetwork
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol JokeGeneratorScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter text: Текст с хорошими делами
  func didReceive(text: String?)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol JokeGeneratorScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> JokeGeneratorScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: JokeGeneratorScreenModel.Language)
}

/// Интерактор
final class JokeGeneratorScreenInteractor: JokeGeneratorScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: JokeGeneratorScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var cloudKitService: ICloudKitService
  private let buttonCounterService: ButtonCounterService
  private var casheJoke: [String] = []
  private var jokeGeneratorScreenModel: JokeGeneratorScreenModel? {
    get {
      storageService.getData(from: JokeGeneratorScreenModel.self)
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
  
  func getContent() {
    let newModel = JokeGeneratorScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )
    
    let model = jokeGeneratorScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
    jokeGeneratorScreenModel = JokeGeneratorScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    
    switch language {
    case .en:
      fetchJokeList(forKey: "JokesLanguageEN") { [weak self] result in
        switch result {
        case let .success(jokeModels):
          self?.casheJoke = jokeModels
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    case .ru:
      fetchJokeList(forKey: "JokesLanguageRU") { [weak self] result in
        switch result {
        case let .success(jokeModels):
          self?.casheJoke = jokeModels
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = jokeGeneratorScreenModel,
          let result = casheJoke.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    jokeGeneratorScreenModel = JokeGeneratorScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> JokeGeneratorScreenModel {
    if let model = jokeGeneratorScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return JokeGeneratorScreenModel(
        result: appearance.result,
        listResult: [],
        language: getDefaultLanguage()
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = JokeGeneratorScreenModel(result: appearance.result,
                                            listResult: [],
                                            language: getDefaultLanguage())
    self.jokeGeneratorScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: JokeGeneratorScreenModel.Language) {
    guard let model = jokeGeneratorScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = JokeGeneratorScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    jokeGeneratorScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension JokeGeneratorScreenInteractor {
  func getDefaultLanguage() -> JokeGeneratorScreenModel.Language {
    let language: JokeGeneratorScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us
    
    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
  
  func fetchJokeList(
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
      recordTypes: .jokes
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

private extension JokeGeneratorScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
