//
//  MainScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {
    
    /// Были получены ячейки
    func didRecive(cells: [MainScreenCell])
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
    
    /// Получаем список ячеек
    func getCells()
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
    
    // MARK: - Internal properties
    
    weak var output: MainScreenInteractorOutput?
    
    // MARK: - Internal func
    
    func getCells() {
        let cells = MainScreenCell.allCases
        output?.didRecive(cells: cells)
    }
}

// MARK: - Appearance

private extension MainScreenInteractor {
    struct Appearance {
        
    }
}
