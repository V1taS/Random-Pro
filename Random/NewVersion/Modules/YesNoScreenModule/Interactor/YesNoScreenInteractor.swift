//
//  YesNoScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 12.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol YesNoScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter result: результат генерации
  func didRecive(result: String?)
  
  /// Возвращает список результатов
  ///  - Parameter listResult: массив результатов
  func didRecive(listResult: [String])
}

protocol YesNoScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные
  func generateContent()
}

final class YesNoScreenInteractor: YesNoScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: YesNoScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var result = Appearance().result
  private var listResult: [String] = []
  
  // MARK: - Initarnal func
  
  func getContent() {
    output?.didRecive(result: result)
    output?.didRecive(listResult: listResult)
  }
  
  func generateContent() {
    let randomElementYesOrNo = Appearance().listAnswer.shuffled().first ?? ""
    listResult.append(randomElementYesOrNo)
    result = randomElementYesOrNo
    
    output?.didRecive(result: result)
    output?.didRecive(listResult: listResult)
  }
}

// MARK: - Private Appearance

private extension YesNoScreenInteractor {
  struct Appearance {
    let listAnswer = [
      NSLocalizedString("Да", comment: ""),
      NSLocalizedString("Нет", comment: "")
    ]
    let result = "?"
  }
}
