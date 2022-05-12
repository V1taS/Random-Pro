//
//  NumberScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenInteractorOutput: AnyObject {
    
    /// Были получены данные для первого и второго поля ввода числа
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func didRecive(firstTextFieldValue: String?,
                   secondTextFieldValue: String?)
    
    /// Были получены данные
    ///  - Parameter result: результат генерации
    func didRecive(result: String?)
    
    /// Возвращает список результатов
    ///  - Parameter listResult: массив результатов
    func didRecive(listResult: [String])
}

protocol NumberScreenInteractorInput: AnyObject {
    
    /// Получить данные
    func getContent()
    
    /// Создать новые данные
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func generateContent(firstTextFieldValue: String?,
                         secondTextFieldValue: String?)
}

final class NumberScreenInteractor: NumberScreenInteractorInput {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenInteractorOutput?
    
    // MARK: - Private property
    
    private let firstTextField = "1"
    private let secondTextField = "10"
    private let result = "?"
    private var listResult: [String] = []
    
    // MARK: - Internal func
    
    func getContent() {
        output?.didRecive(firstTextFieldValue: firstTextField, secondTextFieldValue: secondTextField)
        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
    
    func generateContent(firstTextFieldValue: String?,
                         secondTextFieldValue: String?) {
        let firstValue = firstTextFieldValue ?? ""
        let firstValueNum = Int(firstValue) ?? 0
        
        let secondValue = secondTextFieldValue ?? ""
        let secondValueNum = Int(secondValue) ?? 0
        
        guard firstValueNum < secondValueNum else { return }
        let randomNumber = Int.random(in: firstValueNum...secondValueNum)
        listResult.append("\(randomNumber)")
        
        output?.didRecive(listResult: listResult)
        output?.didRecive(result: "\(randomNumber)")
    }
}
