//
//  QuotesScreenInteractor.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

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
  private var cloudKitService: ICloudKitService
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
    cloudKitService = services.cloudKitService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent() {
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
    
    switch language {
    case .en:
      fetchQuotesList(forKey: "QuotesLanguageEN") { [weak self] result in
        switch result {
        case let .success(quotesList):
          self?.casheQuotes = quotesList
          self?.output?.didReceive(quote: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    case .ru:
      fetchQuotesList(forKey: "QuotesLanguageRU") { [weak self] result in
        switch result {
        case let .success(quotesList):
          self?.casheQuotes = quotesList
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
  
  func fetchQuotesList(
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
      recordTypes: .quotes
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

private extension QuotesScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
