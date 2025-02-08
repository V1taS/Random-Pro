//
//  TextView.swift
//  
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

public final class TextView: UITextView {
  
  // MARK: - Public property
  
  /// Клоужер, который вызывается при нажатии на текст
  public var onTextTap: (() -> Void)?
  
  // MARK: - Public func
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    let point = touch.location(in: self)
    let layoutManager = self.layoutManager
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = self.textContainerOffset()
    let textBoundingBoxWithContainerOffset = textBoundingBox.offsetBy(
      dx: textContainerOffset.x,
      dy: textContainerOffset.y
    )
    
    if textBoundingBoxWithContainerOffset.contains(point) {
      onTextTap?()
    }
    super.touchesEnded(touches, with: event)
  }
  
  private func textContainerOffset() -> CGPoint {
    let padding = textContainer.lineFragmentPadding
    return CGPoint(x: padding, y: .zero)
  }
}
