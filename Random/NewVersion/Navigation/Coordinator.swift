//
//  Coordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import Foundation

protocol FlowCoordinator {
    
    ///  Общий тип данных для клоужера
    associatedtype CallBackTypeObject
    
    ///  Общий тип данных для параметра
    associatedtype InputParameter
    
    ///  Запуск координатора
    ///  - Parameter parameter: Передаем любой параметр в координатор
    func start(parameter: InputParameter)
    
    /// Акшен возвращет какой-то объект
    var callBack: ((CallBackTypeObject) -> Void)? { get set }
}

/// Если `Input` пустой `Void` то функция `start()` без параметра
extension FlowCoordinator where InputParameter == Void {
    func start() {
        start(parameter: ())
    }
}

/// Базовый класс координатора
class Coordinator<Input, CallBackType>: FlowCoordinator {
    typealias CallBackTypeObject = CallBackType
    typealias InputParameter = Input
    
    // MARK: - Internal variables
    
    var callBack: ((CallBackTypeObject) -> Void)?
    
    // MARK: - Internal func
    
    func start(parameter: Input) {
        assert(true, "Should be overrided by subclass")
    }
}
