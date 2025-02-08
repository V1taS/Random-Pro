//
//  NickNameScreenInteractor.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import FancyNetwork
import SKAbstractions

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
  private var cloudKitService: ICloudKitService
  private let buttonCounterService: ButtonCounterService
  private var casheNicks: [String] = []
  private var nickNameScreenModel: NickNameScreenModel? {
    get {
      storageService.getData(from: NickNameScreenModel.self)
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
    fetchNickNameList(forKey: "NicknamesList") { [weak self] result in
      switch result {
      case let .success(listNicks):
        self?.casheNicks = listNicks
        if let model = self?.nickNameScreenModel {
          self?.output?.didReceive(nick: model.result)
        } else {
          let newModel = NickNameScreenModel(
            result: Appearance().result,
            listResult: []
          )
          self?.output?.didReceive(nick: newModel.result)
          self?.nickNameScreenModel = newModel
        }
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateShortButtonAction() {
    var filterArray = casheNicks.filter { $0.count <= 5 }
    filterArray.shuffle()
    let result = filterArray.first ?? ""
    
    if let model = nickNameScreenModel {
      var currentListResult = model.listResult
      currentListResult.append(result)
      
      let newModel = NickNameScreenModel(result: result,
                                         listResult: currentListResult)
      
      nickNameScreenModel = newModel
      output?.didReceive(nick: result)
    } else {
      let newModel = NickNameScreenModel(result: result,
                                         listResult: [result])
      nickNameScreenModel = newModel
      output?.didReceive(nick: result)
    }
    buttonCounterService.onButtonClick()
  }
  
  func generatePopularButtonAction() {
    let result = casheNicks.shuffled().first ?? ""
    
    if let model = nickNameScreenModel {
      var currentListResult = model.listResult
      currentListResult.append(result)
      
      let newModel = NickNameScreenModel(result: result,
                                         listResult: currentListResult)
      
      nickNameScreenModel = newModel
      output?.didReceive(nick: result)
    } else {
      let newModel = NickNameScreenModel(result: result,
                                         listResult: [result])
      nickNameScreenModel = newModel
    }
    buttonCounterService.onButtonClick()
  }
  
  func returnCurrentModel() -> NickNameScreenModel {
    if let model = nickNameScreenModel {
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
    self.nickNameScreenModel = newModel
    output?.didReceive(nick: newModel.result)
    output?.cleanButtonWasSelected()
  }
  
  func fetchNickNameList(
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
      recordTypes: .nicknames
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

private extension NickNameScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
