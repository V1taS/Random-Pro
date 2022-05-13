//
//  DateTimeFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 13.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol DateTimeFactoryOutput: AnyObject {
    
    /// Список результатов был перевернут
    ///  - Parameter listResult: массив результатов
    func didReverse(listResult: [String])
}

protocol DateTimeFactoryInput: AnyObject {
    
    /// Переворачивает список результатов
    ///  - Parameter listResult: массив результатов
    func reverse(listResult: [String])
}

final class DateTimeFactory: DateTimeFactoryInput {
    
    // MARK: - Internal property
    
    weak var output: DateTimeFactoryOutput?
  
    // MARK: - Internal func
    
    func reverse(listResult: [String]) {
        output?.didReverse(listResult: listResult.reversed())
    }
}
