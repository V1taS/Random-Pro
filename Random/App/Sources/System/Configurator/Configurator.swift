//
//  Configurator.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Протокол `Configurator` определяет единственный метод `configure`.
/// Объекты, поддерживающие этот протокол, могут настраивать себя или другие компоненты.
public protocol Configurator {
  /// Метод `configure` предназначен для настройки или конфигурации.
  func configure()
}

/// Расширение для массива `Array`, ограниченное элементами, соответствующими протоколу `Configurator`.
extension Array where Element == Configurator {
  
  /// Метод `configure` для массива вызывает метод `configure` у каждого элемента в массиве.
  /// Это позволяет одновременно настроить все элементы массива, поддерживающие протокол `Configurator`.
  public func configure() {
    forEach { $0.configure() }
  }
}
