//
//  NumberScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenFactoryOutput: AnyObject {
   
    /// Список результатов был перевернут
    ///  - Parameter listResult: массив результатов
    func didReverse(listResult: [String])
}

protocol NumberScreenFactoryInput: AnyObject {
    
    /// Переворачивает список результатов
    ///  - Parameter listResult: массив результатов
    func reverse(listResult: [String])
}

final class NumberScreenFactory: NumberScreenFactoryInput {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenFactoryOutput?
    
    func reverse(listResult: [String]) {
        output?.didReverse(listResult: listResult.reversed())
    }
}
