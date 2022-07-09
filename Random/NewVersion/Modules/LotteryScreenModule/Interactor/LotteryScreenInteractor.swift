//
//  LotteryScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LotteryScreenInteractorOutput: AnyObject {
  
  /// Были получены данные для количественного textField и диапазонов textField
  /// - Parameters:
  ///  - rangeStartValue: стартовый textField диапазона
  ///  - rangeEndValue: финальный textField диапазона
  ///  - amountNumberValue: количественный textField
  func didRecive(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?)
  
  /// Были получены данные
  ///  - Parameter result: результат генерации
  func didRecive(result: String?)
}

protocol LotteryScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные для количественного textField и диапазонов textField
  /// - Parameters:
  ///  - rangeStartValue: стартовый textField диапазона
  ///  - rangeEndValue: финальный textField диапазона
  ///  - amountNumberValue: количественный textField
  func generateContent(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?)
}

final class LotteryScreenInteractor: LotteryScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var result = Appearance().result
  private let rangeStartTextFieldValue = Appearance().startTextFieldValue
  private let rangeEndTextFieldValue = Appearance().endTextFieldValue
  private let amountTextFieldValue = Appearance().startTextFieldValue
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didRecive(result: result)
    output?.didRecive(rangeStartValue: rangeStartTextFieldValue, rangeEndValue: rangeEndTextFieldValue,
                      amountNumberValue: amountTextFieldValue)
  }
  
  func generateContent(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?) {
    let rangeStartValue = rangeStartValue ?? ""
    let rangeStartValueNumber = Int(rangeStartValue) ?? .zero
    
    let rangeEndValue = rangeEndValue ?? ""
    let rangeEndValueNumber = Int(rangeEndValue) ?? .zero
    
    let amountNumberValue = amountNumberValue ?? ""
    let amountNumberValueInt = Int(amountNumberValue) ?? .zero
    
    guard rangeStartValueNumber < rangeEndValueNumber else { return }
    
    let rangeNumber = rangeStartValueNumber...rangeEndValueNumber
    let rangeNumberRandom = rangeNumber.shuffled()
    let rangeNumberRandomString = rangeNumberRandom.map { "\($0)"}
    let arrayResult = Array<String>(rangeNumberRandomString.prefix(amountNumberValueInt))
    let numbersResult = arrayResult.joined(separator: ", ")
    result = numbersResult
    
    output?.didRecive(result: result)
  }
}

// MARK: - Appearance

private extension LotteryScreenInteractor {
  struct Appearance {
    let result = "?"
    let startTextFieldValue = "1"
    let endTextFieldValue = "10"
  }
}
