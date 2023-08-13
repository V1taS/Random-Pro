//
//  MemesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol MemesScreenInteractorOutput: AnyObject {
  
  /// Получен доступ к галерее
  func requestPhotosSuccess()
  
  /// Доступ к галерее не получен
  func requestPhotosError()
  
  /// Были получены данные
  ///  - Parameter memes: Мем
  func didReceive(memes: Data?)
  
  /// Что-то пошло не так
  func somethingWentWrong()
}

/// События которые отправляем от Presenter к Interactor
protocol MemesScreenInteractorInput {
  
  /// Обновить типы доступных мемов
  /// - Parameter type: тип доступных мемов
  func updateMemes(type: [MemesScreenModel.MemesType])
  
  /// Получить данные
  func getContent()
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Запрос доступа к Галерее
  func requestPhotosStatus()
  
  /// Установить новый язык
  func setNewLanguage(language: MemesScreenModel.Language)
  
  /// Запросить текущую модель
  func returnCurrentModel() -> MemesScreenModel
}

/// Интерактор
final class MemesScreenInteractor: MemesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MemesScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var networkService: NetworkService
  private let buttonCounterService: ButtonCounterService
  private let permissionService: PermissionService
  private var memesURLString: [String] = []
  private var memesScreenModel: MemesScreenModel? {
    get {
      storageService.getData(from: MemesScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
    permissionService = services.permissionService
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func updateMemes(type: [MemesScreenModel.MemesType]) {
    let newModel = MemesScreenModel(
      language: returnCurrentModel().language,
      types: type
    )
    memesScreenModel = newModel
    memesURLString = []
  }
  
  func returnCurrentModel() -> MemesScreenModel {
    if let model = memesScreenModel {
      return model
    } else {
      return MemesScreenModel(
        language: getDefaultLanguage(),
        types: [.animals, .work, .popular]
      )
    }
  }
  
  func setNewLanguage(language: MemesScreenModel.Language) {
    guard let model = memesScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = MemesScreenModel(
      language: language,
      types: model.types
    )
    memesScreenModel = newModel
    memesURLString = []
  }
  
  func requestPhotosStatus() {
    permissionService.requestPhotos { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestPhotosSuccess()
      case false:
        self?.output?.requestPhotosError()
      }
    }
  }
  
  func getContent() {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    let newModel = MemesScreenModel(
      language: getDefaultLanguage(),
      types: [.animals, .work, .popular]
    )
    let model = memesScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    let types = model.types.isEmpty ? [.animals, .work, .popular] : model.types
    let typesString = types.compactMap({ $0.rawValue }).joined(separator: ",")
    
    if isEnvironmentDebug() {
      let mockData = [
        "https://random.sosinvitalii.com/memes/popular/ru/test1.jpg",
        "https://random.sosinvitalii.com/memes/popular/ru//test2.jpg"
      ]
      memesURLString = mockData
      generateButtonAction()
      return
    }
    
    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "type", value: typesString),
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
          guard let self else {
            return
          }
          switch result {
          case let .success(data):
            guard let listMemes = self.networkService.map(data, to: [MemesScreenDTO].self) else {
              self.output?.somethingWentWrong()
              return
            }
            self.memesURLString = listMemes.compactMap { $0.urlImage }
            self.generateButtonAction()
          case .failure:
            self.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateButtonAction() {
    memesURLString.shuffle()
    
    guard let memesURLString = memesURLString.first else {
      getContent()
      return
    }
    
    self.memesURLString.removeFirst()
    
    networkService.performRequestWith(
      urlString: memesURLString,
      queryItems: [],
      httpMethod: .get,
      headers: []) { result in
        DispatchQueue.main.async { [weak self] in
          switch result {
          case let .success(data):
            self?.buttonCounterService.onButtonClick()
            self?.output?.didReceive(memes: data)
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }
}

private extension MemesScreenInteractor {
  func getDefaultLanguage() -> MemesScreenModel.Language {
    let languageType = LanguageType.getCurrentLanguageType() ?? .us
    switch languageType {
    case .ru:
      return .ru
    default:
      return .en
    }
  }
  
  func isEnvironmentDebug() -> Bool {
#if DEBUG
    return true
#else
    return false
#endif
  }
}

// MARK: - Appearance

private extension MemesScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/memes"
    let apiKey = "api_key"
    let apiValue = SecretsAPI.fancyBackend
  }
}
