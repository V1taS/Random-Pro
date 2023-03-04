//
//  KeyboardService.swift
//  KeyboardService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class KeyboardServiceImpl: KeyboardServiceProtocol {

  // MARK: - Public properties
  
  public var keyboardHeightChangeAction: ((CGFloat) -> Void)?
  public var keyboardRectChangeAction: ((CGRect) -> Void)?
  
  // MARK: - Initialization
  
  public init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  // MARK: - Private func
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let keyboardRect = (notification.userInfo?[
      UIResponder.keyboardFrameEndUserInfoKey
    ] as? NSValue)?.cgRectValue else { return }
    keyboardRectChangeAction?(keyboardRect)
    keyboardHeightChangeAction?(keyboardRect.height)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    keyboardHeightChangeAction?(.zero)
  }
}
