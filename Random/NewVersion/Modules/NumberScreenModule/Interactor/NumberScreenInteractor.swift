//
//  NumberScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenInteractorOutput: AnyObject {
    
}

protocol NumberScreenInteractorInput: AnyObject {
    
}

final class NumberScreenInteractor: NumberScreenInteractorInput {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenInteractorOutput?
}
