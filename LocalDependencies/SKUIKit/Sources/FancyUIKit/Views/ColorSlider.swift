//
//  ColorSlider.swift
//  
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// Слайдер не интерактивный и без ползунка
public final class ColorSlider: UISlider {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setThumbImage(UIImage(), for: .normal)
    self.isUserInteractionEnabled = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
