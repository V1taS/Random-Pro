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
    ///  - rangeStartValue: Первый textField
    ///  - rangeEndValue: Второй textField
    func didRecive(rangeStartValue: String?,
                   rangeEndValue: String?)
    
    /// Были получены данные
    ///  - Parameter result: результат генерации
    func didRecive(result: String?)
    
    /// Возвращает список результатов
    ///  - Parameter listResult: массив результатов
    func didRecive(listResult: [String])
    
    /// Были получены данные
    ///  - Parameter text: Было получено начало диапазона
    func didReciveRangeStart(text: String?)
    
    /// Были получены данные
    ///  - Parameter text: Было получено конец диапазона
    func didReciveRangeEnd(text: String?)
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
    
    /// Текст в текстовом поле был изменен
    /// - Parameters:
    ///  - text: Значение для текстового поля
    func rangeStartDidChange(_ text: String?)
    
    /// Текст в текстовом поле был изменен
    /// - Parameters:
    ///  - text: Значение для текстового поля
    func rangeEndDidChange(_ text: String?)
}

final class NumberScreenInteractor: NumberScreenInteractorInput {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenInteractorOutput?
    
    // MARK: - Private property
    
    private let rangeStartValue = Appearance().rangeStartValue
    private let rangeEndValue = Appearance().rangeEndValue
    private let result = Appearance().result
    private var listResult: [String] = []
    private lazy var numberFormatter = NumberFormatter()
    
    // MARK: - Internal func
    
    func getContent() {
        output?.didRecive(rangeStartValue: rangeStartValue, rangeEndValue: rangeEndValue)
        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
    
    func generateContent(firstTextFieldValue: String?,
                         secondTextFieldValue: String?) {
        let appearance = Appearance()
        
        let rangeStartValue = (firstTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
        let rangeStartValueNum = Int(rangeStartValue) ?? .zero
        
        let rangeEndValue = (secondTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
        let rangeEndValueNum = Int(rangeEndValue) ?? .zero
        
        guard rangeStartValueNum < rangeEndValueNum else { return }
        let randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
        let randomNumberFormatter = formatter(text: String(randomNumber)) ?? ""
        
        listResult.append(randomNumberFormatter)
        
        output?.didRecive(listResult: listResult)
        output?.didRecive(result: randomNumberFormatter)
    }
    
    func rangeStartDidChange(_ text: String?) {
        let rangeStart = formatter(text: text)
        output?.didReciveRangeStart(text: rangeStart)
    }
    
    func rangeEndDidChange(_ text: String?) {
        let rangeEnd = formatter(text: text)
        output?.didReciveRangeEnd(text: rangeEnd)
    }
}

// MARK: - Private

private extension NumberScreenInteractor {
    private func formatter(text: String?) -> String? {
        guard let text = text else {
            return nil
        }
        
        let appearance = Appearance()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = Appearance().withoutSpaces
        
        let textWithoutSpaces = text.replacingOccurrences(of: appearance.withoutSpaces, with: "")
        
        guard let textNumber = Int(textWithoutSpaces) else {
            return nil
        }
        
        let number = NSNumber(value: textNumber)
        let formatterNumber = numberFormatter.string(from: number)
        return formatterNumber
    }
}

// MARK: - Appearance

private extension NumberScreenInteractor {
    struct Appearance {
        let withoutSpaces = " "
        let rangeStartValue = "1"
        let rangeEndValue = "10"
        let result = "?"
    }
}
