//
//  UITextView+CenterVertical.swift
//  
//
//  Created by Vitalii Sosin on 04.12.2022.
//

import UIKit

public extension UITextView {
  func centerVerticalText() {
    var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
    topCorrect = topCorrect < .zero ? .zero : topCorrect
    self.contentInset.top = topCorrect
  }
}
