//
//  UIImage+Image.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 24.04.2024.
//

import SwiftUI
import UIKit

public extension UIImage {
  var asImage: Image {
    Image(uiImage: self)
  }
}

public extension Optional where Wrapped == UIImage {
  var asImage: Image {
    self.map { Image(uiImage: $0) } ?? Image(systemName: "exclamationmark.warninglight.fill")
  }
}
