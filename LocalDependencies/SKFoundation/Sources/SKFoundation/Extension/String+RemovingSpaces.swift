//
//  String+RemovingSpaces.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 25.04.2024.
//

import Foundation

extension String {
  /// Удалить все пробелы в строке
  public func removingSpaces() -> String {
    return self.replacingOccurrences(of: " ", with: "")
  }
}
