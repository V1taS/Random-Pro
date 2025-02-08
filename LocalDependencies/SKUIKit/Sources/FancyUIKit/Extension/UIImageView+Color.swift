//
//  UIImageView+Color.swift
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

public extension UIImageView {
  
  /// Меняем цвет картинки на свой
  ///  - Parameter color: Выбираем цвет изображения
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
