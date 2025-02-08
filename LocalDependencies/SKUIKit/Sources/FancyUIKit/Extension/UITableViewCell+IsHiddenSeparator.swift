//
//  UITableViewCell+IsHiddenSeparator.swift
//  
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

// MARK: - UITableViewCell

public extension UITableViewCell {
  
  /// Отключить разделитель
  var isHiddenSeparator: Bool {
    get {
      return separatorInset.right == UIScreen.main.bounds.size.width ? true : false
    }
    set {
      let rightInsets = newValue ? UIScreen.main.bounds.size.width : .zero
      separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: rightInsets)
    }
  }
}
