//
//  SlogansScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//

import Foundation
import FancyUIKit
import FancyStyle
import FancyNetwork

/// События которые отправляем из Interactor в Presenter
protocol SlogansScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameter text: Текст со слоганами
  func didReceive(text: String?)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol SlogansScreenInteractorInput {

  /// Получить данные
  func getContent()

  /// Пользователь нажал на кнопку
  func generateButtonAction()

  /// Запросить текущую модель
  func returnCurrentModel() -> SlogansScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Установить новый язык
  func setNewLanguage(language: SlogansScreenModel.Language)
}

/// Интерактор
final class SlogansScreenInteractor: SlogansScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: SlogansScreenInteractorOutput?

  // MARK: - Private property

  private var storageService: StorageService
  private var cloudKitService: ICloudKitService
  private let buttonCounterService: ButtonCounterService
  private var casheSlogans: [String] = []
  private var slogansScreenModel: SlogansScreenModel? {
    get {
      storageService.getData(from: SlogansScreenModel.self)
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
    let newModel = SlogansScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )

    let model = slogansScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()

    slogansScreenModel = SlogansScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    
    switch language {
    case .en:
      fetchSlogansList(forKey: "SlogansLanguageEN") { [weak self] result in
        switch result {
        case let .success(listSlogans):
          self?.casheSlogans = listSlogans
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    case .ru:
      fetchSlogansList(forKey: "SlogansLanguageRU") { [weak self] result in
        switch result {
        case let .success(listSlogans):
          self?.casheSlogans = listSlogans
          self?.output?.didReceive(text: model.result)
        case .failure:
          self?.output?.somethingWentWrong()
        }
      }
    }
  }

  func generateButtonAction() {
    guard let model = slogansScreenModel,
          let result = casheSlogans.shuffled().first else {
      output?.somethingWentWrong()
      return
    }

    var listResult = model.listResult
    listResult.append(result)

    slogansScreenModel = SlogansScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }

  func returnCurrentModel() -> SlogansScreenModel {
    if let model = slogansScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return SlogansScreenModel(
        result: appearance.result,
        listResult: [],
        language: getDefaultLanguage()
      )
    }
  }

  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = SlogansScreenModel(result: appearance.result,
                                      listResult: [],
                                      language: getDefaultLanguage())
    self.slogansScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }

  func setNewLanguage(language: SlogansScreenModel.Language) {
    guard let model = slogansScreenModel else {
      output?.somethingWentWrong()
      return
    }

    let newModel = SlogansScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    slogansScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension SlogansScreenInteractor {
  func getDefaultLanguage() -> SlogansScreenModel.Language {
    let language: SlogansScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us

    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
  
  func fetchSlogansList(
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
      recordTypes: .slogans
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

private extension SlogansScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
