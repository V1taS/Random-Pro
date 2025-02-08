//
//  GlobalLoaderView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 22.10.2024.
//

import UIKit
import Lottie

private let loaderView = LottieAnimationView(name: "loader_circle_new2", bundle: .module)

public func startLoader() {
  DispatchQueue.main.async {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
    
    window.addBackgroundBlurWith(.regular, alpha: 0.9)
    window.addSubview(loaderView)
    
    loaderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loaderView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
      loaderView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: -.s20),
      loaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.3),
      loaderView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.3),
    ])
    
    loaderView.isHidden = false
    loaderView.contentMode = .scaleAspectFit
    loaderView.loopMode = .loop
    loaderView.animationSpeed = 0.5
    loaderView.play()
    window.bringSubviewToFront(loaderView)
  }
}

public func stopLoader() {
  DispatchQueue.main.async {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
    window.removeBackgroundBlur()
    loaderView.stop()
    loaderView.isHidden = true
    loaderView.removeFromSuperview()
  }
}
