//
//  BottleScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol BottleScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol BottleScreenViewInput {
  
}

typealias BottleScreenViewProtocol = UIView & BottleScreenViewInput

final class BottleScreenView: BottleScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenViewOutput?
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private var bottleImageView = UIImageView()
  private let bottomImage = UIImage()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.primaryWhite
    
    bottleImageView.image = appearance.nameBottleImage
    bottleImageView.backgroundColor = .gray
    bottleImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    bottleImageView.contentMode = .center
    
    bottomImage.withTintColor(.yellow)
    
    generateButton.setTitle(appearance.setTextButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc private func generateButtonAction() {

  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [generateButton, bottleImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleSize),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleSize),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleSize),
      
      bottleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
      bottleImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -140)
    ])
  }
}

// MARK: - Appearance

private extension BottleScreenView {
  struct Appearance {
    let setTextButton = NSLocalizedString("Крутить бутылочку", comment: "")
    let middleSize: CGFloat = 16
    let nameBottleImage = UIImage(systemName: "Bottle")
  }
}
