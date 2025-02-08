//
//  InvisibleCursorTextField.swift
//  
//
//  Created by Vitalii Sosin on 17.06.2023.
//

import UIKit

public final class InvisibleCursorTextField: UITextField {
  public override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
  }
}
