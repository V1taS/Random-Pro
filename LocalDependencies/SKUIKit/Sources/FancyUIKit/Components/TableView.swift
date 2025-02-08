//
//  TableView.swift
//  
//
//  Created by Vitalii Sosin on 20.08.2022.
//

import UIKit

/// Кастомная табличка, умеет скролится на текстовом поле и на кнопках
public final class TableView: UITableView {
  public override func touchesShouldCancel(in view: UIView) -> Bool {
    true
  }
}
