//
//  MemesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit
import RandomNetwork
import RandomUIKit

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
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// События которые отправляем от Presenter к Interactor
protocol MemesScreenInteractorInput {
  
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
  
  func returnCurrentModel() -> MemesScreenModel {
    if let model = memesScreenModel {
      return model
    } else {
      return MemesScreenModel(memesURLString: [], language: getDefaultLanguage())
    }
  }
  
  func setNewLanguage(language: MemesScreenModel.Language) {
    guard let model = memesScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = MemesScreenModel(memesURLString: model.memesURLString, language: language)
    memesScreenModel = newModel
    getContent()
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
    output?.startLoader()
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint
    
    let newModel = MemesScreenModel(memesURLString: [], language: getDefaultLanguage())
    let model = memesScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    
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
          guard let self else {
            return
          }
          switch result {
          case let .success(data):
            guard let listMemes = self.networkService.map(data, to: [MemesScreenDTO].self) else {
              self.output?.somethingWentWrong()
              self.output?.stopLoader()
              return
            }
            
            self.memesScreenModel = MemesScreenModel(
              memesURLString: listMemes.compactMap { $0.urlImage },
              language: language
            )
            self.generateButtonAction()
          case .failure:
            self.output?.stopLoader()
            self.output?.somethingWentWrong()
          }
        }
      }
  }
  
  func generateButtonAction() {
    memesScreenModel?.memesURLString.shuffle()
    
    guard let memesURLString = memesScreenModel?.memesURLString.first else {
      getContent()
      return
    }
    
    memesScreenModel?.memesURLString.removeFirst()
    
    networkService.performRequestWith(
      urlString: memesURLString,
      queryItems: [],
      httpMethod: .get,
      headers: []) { result in
        DispatchQueue.main.async { [weak self] in
          switch result {
          case let .success(data):
            self?.output?.stopLoader()
            self?.buttonCounterService.onButtonClick()
            self?.output?.didReceive(memes: data)
          case .failure:
            self?.output?.stopLoader()
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
}

// MARK: - Appearance

private extension MemesScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/memes"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
