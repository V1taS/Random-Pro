//
//  Coordinator.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 16.04.2024.
//

import Foundation

/// Протокол координатора
public protocol FlowCoordnator {
  associatedtype InputParameter
  associatedtype FlowResult
  
  /// Closure выполняющийся по завершению flow
  var finishFlow: ((FlowResult) -> Void)? { get set }
  
  /// Запускает flow
  /// - Parameter parameter: входной параметр
  func start(parameter: InputParameter)
}

/// Базовый класс координатора. Определяет основные методы и свойства для управления потоками (flow) в приложении.
open class Coordinator<Input, Result>: FlowCoordnator {
  
  /// Псевдоним типа для параметра ввода.
  public typealias InputParameter = Input
  /// Псевдоним типа для результата выполнения координатора.
  public typealias FlowResult = Result
  
  /// Замыкание, вызываемое при завершении координатора. Принимает результат координатора.
  open var finishFlow: ((FlowResult) -> Void)?
  
  /// Инициализатор координатора.
  public init() {}
  
  /// Метод для запуска координатора с параметром.
  /// - Parameter parameter: Параметр, с которым запускается координатор.
  open func start(parameter: Input) {
    assert(false, "Должен быть переопределен в подклассе")
  }
}

// MARK: - FlowCoordnator

public extension FlowCoordnator where InputParameter == Void {
  /// Метод для запуска координатора
  func start() {
    start(parameter: ())
  }
}
