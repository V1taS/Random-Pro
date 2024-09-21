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
  private var cloudKitService: ICloudKitService
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
    cloudKitService = services.cloudKitService
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
    memesURLString = []
    
    let appearance = Appearance()
    let newModel = MemesScreenModel(
      language: getDefaultLanguage(),
      types: [.animals, .work, .popular]
    )
    let model = memesScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()
    let types = model.types.isEmpty ? [.animals, .work, .popular] : model.types
    let dispatchGroup = DispatchGroup()
    
    var tempMemesURLString: [String] = []
    for type in types {
      dispatchGroup.enter()
      
      switch type {
      case .work:
        switch language {
        case .en:
          fetchMemesList(forKey: "MemesWorkLanguageEN") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        case .ru:
          fetchMemesList(forKey: "MemesWorkLanguageRU") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        }
      case .animals:
        switch language {
        case .en:
          fetchMemesList(forKey: "MemesAnimalsLanguageEN") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        case .ru:
          fetchMemesList(forKey: "MemesAnimalsLanguageRU") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        }
      case .popular:
        switch language {
        case .en:
          fetchMemesList(forKey: "MemesPopularLanguageEN") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        case .ru:
          fetchMemesList(forKey: "MemesPopularLanguageRU") { result in
            switch result {
            case let .success(listMemes):
              tempMemesURLString.append(contentsOf: listMemes)
            case .failure: break
            }
            dispatchGroup.leave()
          }
        }
      }
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      if tempMemesURLString.isEmpty {
        self?.output?.somethingWentWrong()
      } else {
        self?.memesURLString = tempMemesURLString
        self?.generateButtonAction()
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

// MARK: - Private

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
  
  func fetchMemesList(
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

private extension MemesScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
