//
//  LotteryScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol LotteryScreenInteractorOutput: AnyObject {
    
    /// Были получены данные для первого и второго поля ввода числа
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func didRecive(firstTextFieldValue: String?,
                   secondTextFieldValue: String?, amountTextFieldValue: String?)
    
    /// Были получены данные
    ///  - Parameter result: результат генерации
    func didRecive(result: String?)
}

protocol LotteryScreenInteractorInput: AnyObject {
    
    /// Получить данные
    func getContent()
    
    /// Создать новые данные
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func generateContent(firstTextFieldValue: String?, secondTextFieldValue: String?, amountTextFieldValue: String?)
}

final class LotteryScreenInteractor: LotteryScreenInteractorInput {
    
    // MARK: - Internal property
    
    weak var output: LotteryScreenInteractorOutput?
    
    // MARK: - Private property
    
    private var result = Appearance().result
    private let firstTextFieldValue = "1"
    private let secondTextFieldValue = "10"
    private let amountTextFieldValue = "1"
    
    // MARK: - Internal func
    
    func getContent() {
        output?.didRecive(result: result)
        output?.didRecive(firstTextFieldValue: firstTextFieldValue, secondTextFieldValue: secondTextFieldValue,
                          amountTextFieldValue: amountTextFieldValue)
    }
    
    func generateContent(firstTextFieldValue: String?, secondTextFieldValue: String?, amountTextFieldValue: String?) {
        let firstValue = firstTextFieldValue ?? ""
        let firstValueNumber = Int(firstValue) ?? 0
        
        let secondValue = secondTextFieldValue ?? ""
        let secondValueNumber = Int(secondValue) ?? 0
        
        let amountValue = amountTextFieldValue ?? ""
        let amountValueNumber = Int(amountValue) ?? 0
        
        guard firstValueNumber < secondValueNumber else { return }
        
        let rangeNumber = firstValueNumber...secondValueNumber
        let rangeNumberRandom = rangeNumber.shuffled()
        let rangeNumberRandomString = rangeNumberRandom.map { "\($0)"}
        let arrayResult = Array<String>(rangeNumberRandomString.prefix(amountValueNumber))
        let numbersResult = arrayResult.joined(separator: ", ")
        result = numbersResult
        
        output?.didRecive(result: result)
    }
}

// MARK: - Appearance

private extension LotteryScreenInteractor {
    struct Appearance {
        let result = "?"
    }
}
