//
//  NickNameScreenInteractor.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import RandomNetwork

/// События которые отправляем из Interactor в Presenter
protocol NickNameScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter nick: никнейм
  func didReceive(nick: String?)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol NickNameScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Коротких никнеймов'
  func generateShortButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Популярных никнеймов'
  func generatePopularButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> NickNameScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

/// Интерактор
final class NickNameScreenInteractor: NickNameScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private var casheNicks: [String] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    let appearance = Appearance()
    
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    let apiKey = appearance.apiKey
    let valueType = appearance.valueType
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(setValue: [valueType: apiKey])
      ]) { [weak self] result in
        DispatchQueue.main.async {
          switch result {
          case let .success(data):
            if let listNicks = self?.networkService.map(data, to: [String].self) {
              self?.casheNicks = listNicks
              if let model = self?.storageService.nickNameScreenModel {
                self?.output?.didReceive(nick: model.result)
              } else {
                let newModel = NickNameScreenModel(
                  result: Appearance().result,
                  listResult: []
                )
                self?.output?.didReceive(nick: newModel.result)
                self?.storageService.nickNameScreenModel = newModel
              }
            } else {
              self?.output?.somethingWentWrong()
            }
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateShortButtonAction() {
    var filterArray = casheNicks.filter { $0.count <= 6 }
    filterArray.shuffle()
    let result = filterArray.first ?? ""
    
    if let model = storageService.nickNameScreenModel {
      var currentListResult = model.listResult
      currentListResult.append(result)
      
      let newModel = NickNameScreenModel(result: result,
                                         listResult: currentListResult)
      
      storageService.nickNameScreenModel = newModel
      output?.didReceive(nick: result)
    } else {
      let newModel = NickNameScreenModel(result: result,
                                         listResult: [result])
      storageService.nickNameScreenModel = newModel
    }
  }
  
  func generatePopularButtonAction() {
    let result = casheNicks.shuffled().first ?? ""
    
    if let model = storageService.nickNameScreenModel {
      var currentListResult = model.listResult
      currentListResult.append(result)
      
      let newModel = NickNameScreenModel(result: result,
                                         listResult: currentListResult)
      
      storageService.nickNameScreenModel = newModel
      output?.didReceive(nick: result)
    } else {
      let newModel = NickNameScreenModel(result: result,
                                         listResult: [result])
      storageService.nickNameScreenModel = newModel
    }
  }
  
  func returnCurrentModel() -> NickNameScreenModel {
    if let model = storageService.nickNameScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return NickNameScreenModel(
        result: appearance.result,
        listResult: []
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = NickNameScreenModel(result: appearance.result,
                                       listResult: [])
    self.storageService.nickNameScreenModel = newModel
    output?.didReceive(nick: newModel.result)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Appearance

private extension NickNameScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/nickname"
    let apiKey = "api_key"
    let valueType = "4t2AceLVaSW88H8wJ1f6"
  }
}
