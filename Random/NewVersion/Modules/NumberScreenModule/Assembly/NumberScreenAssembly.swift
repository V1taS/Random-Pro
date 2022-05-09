//
//  NumberScreenAssembly.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

final class NumberScreenAssembly {
    
    /// Собирает модуль `NumberScreen`
    func createModule() -> NumberScreenModule {
        let view = NumberScreenView()
        let interactor = NumberScreenInteractor()
        let factory = NumberScreenFactory()
        let presenter = NumberScreenViewController(moduleView: view, interactor: interactor, factory: factory)
        
        view.output = presenter
        interactor.output = presenter
        factory.output = presenter
        return presenter
    }
}
