//
//  NickNameScreenInteractor.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol NickNameScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter nick: никнейм
  func didReceive(nick: String?)
  
  /// Были загружены данные
  func contentLoadedSuccessfully()
  
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
  private var casheNicks: [String] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    // TODO: - Сделать запрос в сеть для получения списка ников
    //    sleep(3)
    let someArray = ["Пьяная белка", "Ангел-Предохранитель", "[SуперМэнка]", "Йожик", "ZEFIRKA:)", "Apple", "кот",
                     "милое олицетворение зла", "your_problem", "Blackkiller", "!B-DOG!", "!Dead|LeGioN| Бабушка",
                     "Darya", "ChupaChups", "CHLENIX|ON", "Ты", "Swit", "Pig"]
    
    casheNicks = someArray
    output?.contentLoadedSuccessfully()
    
    if let model = storageService.nickNameScreenModel {
      output?.didReceive(nick: model.result)
    } else {
      let newModel = NickNameScreenModel(
        result: Appearance().result,
        listResult: []
      )
      output?.didReceive(nick: newModel.result)
      storageService.nickNameScreenModel = newModel
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
    output?.didReceive(nick: casheNicks.shuffled().first)
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
  }
}
