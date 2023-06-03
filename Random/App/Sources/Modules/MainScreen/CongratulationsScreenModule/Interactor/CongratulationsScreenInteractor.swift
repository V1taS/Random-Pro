//
//  CongratulationsScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import RandomNetwork
import RandomUIKit

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
  private var networkService: NetworkService
  private var buttonCounterService: ButtonCounterService
  private var casheCongratulations: [String] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent(type: CongratulationsScreenModel.CongratulationsType?) {
    let newModel = CongratulationsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .birthday
    )
    let model = storageService.congratulationsScreenModel ?? newModel
    let type = type ?? (model.type ?? .birthday)
    let language = model.language ?? getDefaultLanguage()
    
    storageService.congratulationsScreenModel = CongratulationsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: type
    )
    
    fetchListNames(type: type,
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
    guard let model = storageService.congratulationsScreenModel,
          let result = casheCongratulations.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    storageService.congratulationsScreenModel = CongratulationsScreenModel(
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
    self.storageService.congratulationsScreenModel = newModel
    output?.didReceive(name: newModel.result, type: newModel.type ?? .birthday)
    output?.cleanButtonWasSelected()
  }
  
  func segmentedControlValueDidChange(type: CongratulationsScreenModel.CongratulationsType?) {
    getContent(type: type)
  }
  
  func setNewLanguage(language: CongratulationsScreenModel.Language) {
    guard let model = storageService.congratulationsScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = CongratulationsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: model.type
    )
    storageService.congratulationsScreenModel = newModel
    getContent(type: nil)
  }
  
  func returnCurrentModel() -> CongratulationsScreenModel {
    if let model = storageService.congratulationsScreenModel {
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
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "type", value: type.rawValue),
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
          guard let listCongratulations = self.networkService.map(data, to: [String].self) else {
            completion(.failure(NetworkError.mappingError))
            return
          }
          completion(.success(listCongratulations))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }
  }
  
  func getDefaultLanguage() -> CongratulationsScreenModel.Language {
    let language: CongratulationsScreenModel.Language
    let localeType = getCurrentLocaleType() ?? .us
    
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

private extension CongratulationsScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/congratulations"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}