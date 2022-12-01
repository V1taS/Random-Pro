//
//  KeyboardService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol KeyboardService {
  
  /// Действие, изменения высоты клавиатуры
  ///  - Parameter height: Высота клавиатуры
  var keyboardHeightChangeAction: ((CGFloat) -> Void)? { get set }
  
  /// Действие, изменения высоты клавиатуры
  ///  - Parameter rect: Расположение и размеры прямоугольника.
  var keyboardRectChangeAction: ((CGRect) -> Void)? { get set }
}

final class KeyboardServiceImpl: KeyboardService {
  
  // MARK: - Internal properties
  
  var keyboardHeightChangeAction: ((CGFloat) -> Void)?
  var keyboardRectChangeAction: ((CGRect) -> Void)?
  
  // MARK: - Initialization
  
  init() {
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
