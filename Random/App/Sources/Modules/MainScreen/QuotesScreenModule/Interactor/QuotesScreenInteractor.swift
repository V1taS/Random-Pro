//
//  QuotesScreenInteractor.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit
import RandomNetwork
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol QuotesScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter quote: Текст с цитатой
  func didReceive(quote: String?)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol QuotesScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> QuoteScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: QuoteScreenModel.Language)
}

/// Интерактор
final class QuotesScreenInteractor: QuotesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: QuotesScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private let buttonCounterService: ButtonCounterService
  private var casheQuotes: [String] = []
  private var quoteGeneratorScreenModel: QuoteScreenModel? {
    get {
      storageService.getData(from: QuoteScreenModel.self)
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
  
  func getContent() {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    let newModel = QuoteScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )
    
    let model = quoteGeneratorScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
    quoteGeneratorScreenModel = QuoteScreenModel(
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
            self?.casheQuotes = listGoodDeeds
            self?.output?.didReceive(quote: model.result)
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateButtonAction() {
    guard let model = quoteGeneratorScreenModel,
          let result = casheQuotes.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    quoteGeneratorScreenModel = QuoteScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(quote: result)
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> QuoteScreenModel {
    if let model = quoteGeneratorScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return QuoteScreenModel(
        result: appearance.result,
        listResult: [],
        language: getDefaultLanguage()
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = QuoteScreenModel(result: appearance.result,
                                        listResult: [],
                                        language: getDefaultLanguage())
    self.quoteGeneratorScreenModel = newModel
    output?.didReceive(quote: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: QuoteScreenModel.Language) {
    guard let model = quoteGeneratorScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = QuoteScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    quoteGeneratorScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension QuotesScreenInteractor {
  func getDefaultLanguage() -> QuoteScreenModel.Language {
    let language: QuoteScreenModel.Language
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

private extension QuotesScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/quotes"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
