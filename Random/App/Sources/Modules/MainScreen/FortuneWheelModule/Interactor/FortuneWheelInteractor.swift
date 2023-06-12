//
//  FortuneWheelInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomWheel

/// События которые отправляем из Interactor в Presenter
protocol FortuneWheelInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - model: Модель данных
  func didReceive(model: FortuneWheelModel)
}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelInteractorInput {
  
  /// Получить данные
  func getContent()
}

/// Интерактор
final class FortuneWheelInteractor: FortuneWheelInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    let model = FortuneWheelModel(
      result: nil,
      listResult: [
        .init(title: "$1",
              description: nil,
              image: nil),
        .init(title: "$1",
              description: nil,
              image: nil),
      ],
      style: .regular,
      sections: [],
      selectedSection: .init(
        title: "Секция вопросов",
        icon: nil,
        objects: [
          .init(title: "$1",
                description: nil,
                image: nil),
          .init(title: "$2",
                description: nil,
                image: nil),
          .init(title: "LOSE",
                description: nil,
                image: nil),
          .init(title: "$3",
                description: nil,
                image: nil),
          .init(title: "$4",
                description: nil,
                image: nil),
          .init(title: "$5",
                description: nil,
                image: nil),
          .init(title: "$6",
                description: nil,
                image: nil),
          .init(title: "$7",
                description: nil,
                image: nil),
          .init(title: "$8",
                description: nil,
                image: nil),
        ]),
      isEnabledSound: true,
      isEnabledFeedback: true
    )
    output?.didReceive(model: model)
  }
}

// MARK: - Private

private extension FortuneWheelInteractor {}

// MARK: - Appearance

private extension FortuneWheelInteractor {
  struct Appearance {}
}
