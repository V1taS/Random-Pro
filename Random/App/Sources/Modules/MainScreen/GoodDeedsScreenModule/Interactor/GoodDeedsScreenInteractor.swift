//
//  GoodDeedsScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit
import RandomNetwork
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol GoodDeedsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter text: Текст с хорошими делами
  func didReceive(text: String?)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol GoodDeedsScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> GoodDeedsScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: GoodDeedsScreenModel.Language)
}

/// Интерактор
final class GoodDeedsScreenInteractor: GoodDeedsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: GoodDeedsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private let buttonCounterService: ButtonCounterService
  private var casheGoodDeeds: [String] = []
  
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
    
    let newModel = GoodDeedsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )
    
    let model = storageService.goodDeedsScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
    storageService.goodDeedsScreenModel = GoodDeedsScreenModel(
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
            self?.casheGoodDeeds = listGoodDeeds
            self?.output?.didReceive(text: model.result)
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateButtonAction() {
    guard let model = storageService.goodDeedsScreenModel,
          let result = casheGoodDeeds.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    storageService.goodDeedsScreenModel = GoodDeedsScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> GoodDeedsScreenModel {
    if let model = storageService.goodDeedsScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return GoodDeedsScreenModel(
        result: appearance.result,
        listResult: [],
        language: getDefaultLanguage()
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = GoodDeedsScreenModel(result: appearance.result,
                                        listResult: [],
                                        language: getDefaultLanguage())
    self.storageService.goodDeedsScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: GoodDeedsScreenModel.Language) {
    guard let model = storageService.goodDeedsScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = GoodDeedsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    storageService.goodDeedsScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension GoodDeedsScreenInteractor {
  func getDefaultLanguage() -> GoodDeedsScreenModel.Language {
    let language: GoodDeedsScreenModel.Language
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

private extension GoodDeedsScreenInteractor {
  struct Appearance {
    let result = "?"
    
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/goodDeeds"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
