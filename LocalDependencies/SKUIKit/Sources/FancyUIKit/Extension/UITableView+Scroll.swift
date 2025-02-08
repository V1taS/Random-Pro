//
//  UITableView+Scroll.swift
//  
//
//  Created by Vitalii Sosin on 14.08.2022.
//

import UIKit

/// Скролл в табличке
extension UITableView {
  
  /// Скролл к низу табличке
  /// - Parameter isAnimated: Анимация
  public func scrollToBottom(isAnimated: Bool = true){
    DispatchQueue.main.async {
      let indexPath = IndexPath(
        row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
        section: self.numberOfSections - 1)
      if self.hasRowAtIndexPath(indexPath: indexPath) {
        self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
      }
    }
  }
  
  /// Скролл к верху табличке
  /// - Parameter isAnimated: Анимация
  public func scrollToTop(isAnimated: Bool = true) {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: .zero, section: .zero)
      if self.hasRowAtIndexPath(indexPath: indexPath) {
        self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
      }
    }
  }
  
  private func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections &&
    indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }
}
