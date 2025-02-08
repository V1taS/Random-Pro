//
//  TableView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit

/// Кастомная табличка, умеет скролится на текстовом поле и на кнопках
public final class TableView: UITableView {
  public override func touchesShouldCancel(in view: UIView) -> Bool {
    true
  }
}
