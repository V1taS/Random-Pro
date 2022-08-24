//
//  ListScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ListScreenViewOutput: AnyObject {}

/// События которые отправляем из Presenter во View
protocol ListScreenViewInput {}

/// Псевдоним протокола UIView & ListScreenViewInput
typealias ListScreenViewProtocol = UIView & ListScreenViewInput

final class ListScreenView: ListScreenViewProtocol {
  
  // MARK: - Internal property

  weak var output: ListScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  
  // MARK: - Initialization
  
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
    
    resultLabel.text = appearance.titleButton
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    
    generateButton.setTitle(appearance.titleButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .valueChanged)
  }
  
  @objc private func generateButtonAction() {}
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.mediumSpasing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.mediumSpasing),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.mediumSpasing),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.mediumSpasing),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.mediumSpasing)
    ])
  }
}

// MARK: - Appearance

extension ListScreenView {
  struct Appearance {
    let titleButton = NSLocalizedString("Сгенерировать", comment: "")
    let titleResult = "?"
    let mediumSpasing: CGFloat = 16
  }
}
