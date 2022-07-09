//
//  YesNoScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol YesNoScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: YesNoScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: YesNoScreenModel)
}

protocol YesNoScreenInteractorInput: AnyObject {
  
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
  
  @ObjectCustomUserDefaultsWrapper<YesNoScreenModel>(key: Appearance().keyUserDefaults)
  private var model: YesNoScreenModel?
  
  // MARK: - Initarnal func
  
  func cleanButtonAction() {
    model = nil
    getContent()
    guard let model = model else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    if let model = model {
      output?.didRecive(model: model)
    } else {
      let appearance = Appearance()
      let model = YesNoScreenModel(result: appearance.result,
                                   listResult: [])
      self.model = model
      output?.didRecive(model: model)
    }
  }
  
  func generateContent() {
    guard let model = model else {
      return
    }
    
    let randomElementYesOrNo = Appearance().listResult.shuffled().first ?? ""
    var listResult: [String] = model.listResult
    
    listResult.append(randomElementYesOrNo)
    let newModel = YesNoScreenModel(result: randomElementYesOrNo,
                                    listResult: listResult)
    self.model = newModel
    output?.didRecive(model: newModel)
  }
}

// MARK: - Private Appearance

private extension YesNoScreenInteractor {
  struct Appearance {
    let listResult = [
      NSLocalizedString("Да", comment: ""),
      NSLocalizedString("Нет", comment: "")
    ]
    let result = "?"
    let keyUserDefaults = "yes_no_screen_user_defaults_key"
  }
}
