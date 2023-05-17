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
  
  /// Были получены данные
  ///  - Parameter nick: никнейм
  func contentLoadedSuccessfully()
}

/// События которые отправляем от Presenter к Interactor
protocol NickNameScreenInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> NickNameScreenModel
  
  /// Получить данные
  func getContent()
  
  func generateShortButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Популярных никнеймов'
  func generatePopularButtonAction()
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
  
  func generateShortButtonAction() {
    // TODO: - 1) Фильтруем массив по количеству символов, например до 6 символов
    // TODO: - 2) Перемешиваем массив
    // TODO: - 3) берем первый элемент и отправляем в презентер

    
    
    output?.didReceive(nick: "")
  }
  
  func generatePopularButtonAction() {
    output?.didReceive(nick: casheNicks.shuffled().first)
  }
  
  func getContent() {
    // TODO: - Сделать запрос в сеть для получения списка ников
    sleep(3)
    var array = ["adac", "sfsvsxbvsv"]
    casheNicks = array
    output?.contentLoadedSuccessfully()
  }
  
  func returnCurrentModel() -> NickNameScreenModel {
    if let model = storageService.nickNameScreenModel {
      return model
    } else {
      return NickNameScreenModel(result: "?",
                                 indexSegmented: 5,
                                 listResult: [],
                                 isEnabledWithoutRepetition: true
      )
    }
  }
}

// MARK: - Appearance

private extension NickNameScreenInteractor {
  struct Appearance {}
}
