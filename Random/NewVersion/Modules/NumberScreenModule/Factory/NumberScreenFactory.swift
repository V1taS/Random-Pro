//
//  NumberScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenFactoryOutput: AnyObject {
    
}

protocol NumberScreenFactoryInput: AnyObject {
    
}

final class NumberScreenFactory: NumberScreenFactoryInput {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenFactoryOutput?
}
