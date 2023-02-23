//
//  YesNoScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import ApplicationInterface

protocol YesNoScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: YesNoScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: YesNoScreenModel)
}

protocol YesNoScreenInteractorInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Получить данные
  func getContent()
  
  /// Нажата кнопка сгенераровать данные
  func generateContent()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

final class YesNoScreenInteractor: YesNoScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: YesNoScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageServiceProtocol
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис хранения данных
  init(storageService: StorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Initarnal func
  
  func cleanButtonAction() {
    storageService.yesNoScreenModel = nil
    getContent()
    guard let model = storageService.yesNoScreenModel?.toCodable() else {
      return
    }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    if let model = storageService.yesNoScreenModel?.toCodable() {
      output?.didReceive(model: model)
    } else {
      let appearance = Appearance()
      let model = YesNoScreenModel(result: appearance.result,
                                   listResult: [])
      self.storageService.yesNoScreenModel = model
      output?.didReceive(model: model)
    }
  }
  
  func generateContent() {
    guard let model = storageService.yesNoScreenModel else {
      return
    }
    
    let randomElementYesOrNo = Appearance().listResult.shuffled().first ?? ""
    var listResult: [String] = model.listResult
    
    listResult.append(randomElementYesOrNo)
    let newModel = YesNoScreenModel(result: randomElementYesOrNo,
                                    listResult: listResult)
    self.storageService.yesNoScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnListResult() -> [String] {
    if let model = storageService.yesNoScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
}

// MARK: - Appearance

private extension YesNoScreenInteractor {
  struct Appearance {
    let listResult = [
      NSLocalizedString("Да", comment: ""),
      NSLocalizedString("Нет", comment: "")
    ]
    let result = "?"
  }
}
