//
//  LetterScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//
import UIKit

protocol LetterScreenFactoryOutput: AnyObject {
    
    /// Список результатов был перевернут
    ///  - Parameter listResult: массив результатов
    func didReverse(listResult: [String])
}

protocol LetterScreenFactoryInput: AnyObject {
    
    /// Переворачивает список результатов
    ///  - Parameter listResult: массив результатов
    func resive(listResult: [String])
}

final class LetterScreenFactory: LetterScreenFactoryInput {
    
    // MARK: - Initarnal property
    
    weak var output: LetterScreenFactoryOutput?
    
    // MARK: - Initarnal func
    
    func resive(listResult: [String]) {
        output?.didReverse(listResult: listResult.reversed())
    }
}
