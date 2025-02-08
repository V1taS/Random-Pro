//
//  CheckmarkView+Model.swift
//
//
//  Created by Vitalii Sosin on 04.02.2024.
//

import SwiftUI

// MARK: - Checkmark Style

extension CheckmarkView {
  public enum Style {
    /// Квадратный
    case rectangle
    /// Круглый
    case circle
    
    func createSystemName(_ toggleValue: Bool) -> String {
      switch self {
      case .rectangle:
        return toggleValue ? "checkmark.square" : "square"
      case .circle:
        return toggleValue ? "record.circle" : "circle"
      }
    }
  }
}
