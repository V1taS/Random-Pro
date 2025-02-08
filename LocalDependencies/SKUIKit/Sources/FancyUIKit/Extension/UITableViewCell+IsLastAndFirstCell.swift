//
//  UITableViewCell+IsLastAndFirstCell.swift
//  
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

// MARK: - UITableView

public extension UITableView {
  
  /// Поиск первой ячейки в табличке
  func isFirst(for indexPath: IndexPath) -> Bool {
    indexPath.section == .zero && indexPath.row == .zero
  }
  
  /// Поиск последней ячейки в табличке
  func isLast(for indexPath: IndexPath) -> Bool {
    let indexOfLastSection = numberOfSections > .zero ? numberOfSections - 1 : .zero
    let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1
    
    return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
  }
}
