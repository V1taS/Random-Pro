//
//  LetterScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//
import UIKit

protocol LetterScreenFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter model: Модель
  func didReverseListResult(model: LetterScreenModel)
}

protocol LetterScreenFactoryInput: AnyObject {
  
  /// Переворачивает список результатов
  ///  - Parameter model: Модель
  func reverseListResultFrom(model: LetterScreenModel)
}

final class LetterScreenFactory: LetterScreenFactoryInput {
  
  // MARK: - Initarnal property
  
  weak var output: LetterScreenFactoryOutput?
  
  // MARK: - Initarnal func
  
  func reverseListResultFrom(model: LetterScreenModel) {
    let newModel = LetterScreenModel(
      result: model.result,
      listResult: model.listResult.reversed(),
      isEnabledWithoutRepetition: model.isEnabledWithoutRepetition,
      languageIndexSegmented: model.languageIndexSegmented
    )
    output?.didReverseListResult(model: newModel)
  }
}
