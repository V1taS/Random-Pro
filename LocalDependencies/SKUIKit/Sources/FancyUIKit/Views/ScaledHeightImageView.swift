//
//  ScaledHeightImageView.swift
//  
//
//  Created by Vitalii Sosin on 10.09.2022.
//

import UIKit

/// ImageView без прозрачных отступов
public final class ScaledHeightImageView: UIImageView {
  
  public override var intrinsicContentSize: CGSize {
    if let myImage = self.image {
      let myImageWidth = myImage.size.width
      let myImageHeight = myImage.size.height
      let myViewWidth = self.frame.size.width
      let ratio = myViewWidth/myImageWidth
      let scaledHeight = myImageHeight * ratio
      
      return CGSize(width: myViewWidth, height: scaledHeight)
    }
    
    return CGSize(width: -1.0, height: -1.0)
  }
}
