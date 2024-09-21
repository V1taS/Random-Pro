//
//  GoodDeedsScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

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
  private var cloudKitService: ICloudKitService
  private let buttonCounterService: ButtonCounterService
  private var casheGoodDeeds: [String] = []
  private var goodDeedsScreenModel: GoodDeedsScreenModel? {
    get {
      storageService.getData(from: GoodDeedsScreenModel.self)
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
    let newModel = GoodDeedsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )
    
    let model = goodDeedsScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
    goodDeedsScreenModel = GoodDeedsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    
    switch language {
    case .en:
      fetchGoodDeedsList(forKey: "GoodDeedsLanguageEN") { [weak self] result in
        switch result {
        case let .success(listGoodDeeds):
          self?.casheGoodDeeds = listGoodDeeds
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    case .ru:
      fetchGoodDeedsList(forKey: "GoodDeedsLanguageRU") { [weak self] result in
        switch result {
        case let .success(listGoodDeeds):
          self?.casheGoodDeeds = listGoodDeeds
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = goodDeedsScreenModel,
          let result = casheGoodDeeds.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    goodDeedsScreenModel = GoodDeedsScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> GoodDeedsScreenModel {
    if let model = goodDeedsScreenModel {
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
    self.goodDeedsScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func setNewLanguage(language: GoodDeedsScreenModel.Language) {
    guard let model = goodDeedsScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = GoodDeedsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    goodDeedsScreenModel = newModel
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
  
  func fetchGoodDeedsList(
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

private extension GoodDeedsScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
