//
//  View+AsUIImage.swift
//
//
//  Created by Vitalii Sosin on 10.12.2023.
//

import SwiftUI

public extension View {
  func asUIImage() -> UIImage {
    let controller = UIHostingController(rootView: self)
    let view = controller.view
    
    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}
