//
//  Array+Safe.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 22.06.2024.
//

import Foundation

extension Array {
  /// Безопасный сабскрипт для доступа к элементу по индексу.
  ///
  /// - Parameter index: Индекс элемента.
  /// - Returns: Элемент, если индекс в пределах массива, иначе nil.
  subscript(safe index: Int) -> Element? {
    // Проверяем, находится ли индекс в пределах массива
    return indices.contains(index) ? self[index] : nil
  }
}
