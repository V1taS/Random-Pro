//
//  JokeGeneratorScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import RandomUIKit
import RandomNetwork

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
  private var networkService: NetworkService
  private let buttonCounterService: ButtonCounterService
  private var casheJoke: [String] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    let newModel = JokeGeneratorScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )
    
    let model = storageService.jokeGeneratorScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
    storageService.jokeGeneratorScreenModel = JokeGeneratorScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "language", value: "\(language.rawValue)")
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]) { result in
        DispatchQueue.main.async { [weak self] in
          switch result {
          case let .success(data):
            guard let listGoodDeeds = self?.networkService.map(data, to: [String].self) else {
              self?.output?.somethingWentWrong()
              return
            }
            self?.casheJoke = listGoodDeeds
            self?.output?.didReceive(text: model.result)
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateButtonAction() {
    guard let model = storageService.jokeGeneratorScreenModel,
          let result = casheJoke.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    storageService.jokeGeneratorScreenModel = JokeGeneratorScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> JokeGeneratorScreenModel {
    if let model = storageService.jokeGeneratorScreenModel {
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
    self.storageService.jokeGeneratorScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: JokeGeneratorScreenModel.Language) {
    guard let model = storageService.jokeGeneratorScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = JokeGeneratorScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    storageService.jokeGeneratorScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension JokeGeneratorScreenInteractor {
  func getDefaultLanguage() -> JokeGeneratorScreenModel.Language {
    let language: JokeGeneratorScreenModel.Language
    let localeType = getCurrentLocaleType() ?? .us
    
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

private extension JokeGeneratorScreenInteractor {
  struct Appearance {
    let result = "?"
    
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/jokes"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
