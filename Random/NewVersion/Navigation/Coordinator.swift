//
//  Coordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import Foundation

protocol FlowCoordinator {
    
    ///  Общий тип данных для клоужера
    associatedtype FinishFlowTypeObject
    
    ///  Общий тип данных для параметра
    associatedtype InputParameter
    
    ///  Запуск координатора
    ///  - Parameter parameter: Передаем любой параметр в координатор
    func start(parameter: InputParameter)
    
    /// Акшен возвращет какой-то объект
    var finishFolw: ((FinishFlowTypeObject) -> Void)? { get set }
}

/// Если `Input` пустой `Void` то функция `start()` без параметра
extension FlowCoordinator where InputParameter == Void {
    func start() {
        start(parameter: ())
    }
}

/// Базовый класс координатора
class Coordinator<Input, FinishFlowType>: FlowCoordinator {
    typealias FinishFlowTypeObject = FinishFlowType
    typealias InputParameter = Input
    
    // MARK: - Internal variables
    
    var finishFolw: ((FinishFlowTypeObject) -> Void)?
    
    // MARK: - Internal func
    
    func start(parameter: Input) {
        assert(true, "Should be overrided by subclass")
    }
}
