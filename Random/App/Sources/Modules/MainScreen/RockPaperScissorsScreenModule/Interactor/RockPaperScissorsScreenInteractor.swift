//
//  RockPaperScissorsScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol RockPaperScissorsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  /// - Parameter model: модель с данными
  func didReceive(model: RockPaperScissorsScreenModel)
  
  /// Создать начальную модель
  func createStartModel()
}

/// События которые отправляем от Presenter к Interactor
protocol RockPaperScissorsScreenInteractorInput {
  
  ///  Сохранить модель
  /// - Parameter model: модель с данными
  func saveModel(model: RockPaperScissorsScreenModel)
  
  /// Получить данные
  func getContent()
}

final class RockPaperScissorsScreenInteractor: RockPaperScissorsScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var model: RockPaperScissorsScreenModel?
  private let buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = model {
      output?.didReceive(model: model)
    } else {
      output?.createStartModel()
    }
    buttonCounterService.onButtonClick()
  }
  
  func saveModel(model: RockPaperScissorsScreenModel) {
    self.model = model
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenInteractor {}
