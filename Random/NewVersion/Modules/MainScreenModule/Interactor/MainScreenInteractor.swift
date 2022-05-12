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
    ///  - Parameter cells: Массив ячеек на главном экране
    func didRecive(cells: [MainScreenCellModel.MainScreenCell])
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
    
    /// Получаем список ячеек
    func getCells()
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
    
    // MARK: - Private properties
    
    // TODO: -  Повесить фича тогл на отключение ячеек
    // TODO: -  Сделать настройку ADV лайблов
    private let featureToggles: [MainScreenCellModel.MainScreenCell] = [
        .films(advLabel: .none),
        .teams(advLabel: .none),
        .character(advLabel: .none),
        .list(advLabel: .none),
        .coin(advLabel: .none),
        .cube(advLabel: .none),
        .dateAndTime(advLabel: .none),
        .lottery(advLabel: .none),
        .contact(advLabel: .none),
        .music(advLabel: .none),
        .travel(advLabel: .none),
        .password(advLabel: .none),
        .russianLotto(advLabel: .none)
    ]
    
    // MARK: - Internal properties
    
    weak var output: MainScreenInteractorOutput?
    
    // MARK: - Internal func
    
    func getCells() {
        var cells: [MainScreenCellModel.MainScreenCell] = []
        
        MainScreenCellModel.MainScreenCell.allCases.forEach { cell in
            if checkIsShow(cell: cell,
                           featureToggles: featureToggles) {
                cells.append(cell)
            }
        }
        
        output?.didRecive(cells: cells)
    }
    
    // MARK: - Private func
    
    /// Фича тогл, для выключения определенных ячеек
    /// - Parameters:
    ///   - cell: Ячейка которую проверяем, скрытая ли она
    ///   - featureToggles: список ячеек которые не показываем на экране
    private func checkIsShow(cell: MainScreenCellModel.MainScreenCell,
                             featureToggles: [MainScreenCellModel.MainScreenCell]) -> Bool {
        !featureToggles.contains(cell)
    }
}

// MARK: - Appearance

private extension MainScreenInteractor {
    struct Appearance {
        
    }
}
