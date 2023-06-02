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
    let model = storageService.goodDeedsScreenModel ?? returnCurrentModel()
    
    if storageService.goodDeedsScreenModel == nil {
      storageService.goodDeedsScreenModel = returnCurrentModel()
    }
    
    let language: GoodDeedsScreenModel.Language
    let currentRegionType = getCurrentLocaleType() ?? .us
    
    switch currentRegionType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    
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
      listResult: listResult
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
        listResult: []
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = GoodDeedsScreenModel(result: appearance.result,
                                        listResult: [])
    self.storageService.goodDeedsScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
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
