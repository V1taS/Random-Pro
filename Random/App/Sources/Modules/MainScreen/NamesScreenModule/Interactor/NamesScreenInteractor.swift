//
//  NamesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import RandomNetwork
import RandomUIKit

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
  private var networkService: NetworkService
  private var casheNames: [String] = []
  private let buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
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
    let model = storageService.namesScreenModel ?? newModel
    let gender = gender ?? (model.gender ?? .male)
    let language = model.language ?? getDefaultLanguage()
    
    storageService.namesScreenModel = NamesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: gender
    )
    
    fetchListNames(gender: gender,
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
    guard let model = storageService.namesScreenModel,
          let result = casheNames.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    storageService.namesScreenModel = NamesScreenModel(
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
    guard let model = storageService.namesScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = NamesScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: model.gender
    )
    storageService.namesScreenModel = newModel
    getContent(gender: nil)
  }
  
  func returnCurrentModel() -> NamesScreenModel {
    if let model = storageService.namesScreenModel {
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
    self.storageService.namesScreenModel = newModel
    output?.didReceive(name: newModel.result, gender: newModel.gender ?? .male)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension NamesScreenInteractor {
  func fetchListNames(gender: NamesScreenModel.Gender,
                      language: NamesScreenModel.Language,
                      completion: @escaping (Result<[String], Error>) -> Void) {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "gender", value: gender.rawValue),
        .init(name: "language", value: language.rawValue)
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]
    ) { [weak self] result in
      guard let self else {
        return
      }
      DispatchQueue.main.async {
        
        switch result {
        case let .success(data):
          guard let listNames = self.networkService.map(data, to: [String].self) else {
            completion(.failure(NetworkError.mappingError))
            return
          }
          completion(.success(listNames))
        case let .failure(error):
          completion(.failure(error))
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
}

// MARK: - Appearance

private extension NamesScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/names"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
