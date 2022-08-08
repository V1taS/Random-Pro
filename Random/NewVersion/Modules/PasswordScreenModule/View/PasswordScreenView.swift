//
//  PasswordScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol PasswordScreenViewOutput: AnyObject {}

protocol PasswordScreenViewInput {}

typealias PasswordScreenViewProtocol = UIView & PasswordScreenViewInput

final class PasswordScreenView: PasswordScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenViewOutput?
  
  // MARK: - Private property
  
  private let passwordSegmentedControl = UISegmentedControl()
  private let passwordGeneratorView = PasswordGeneratorView()
  private let phrasePasswordView = PhrasePasswordView()
  private let genarateButton = ButtonView()
  
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
    backgroundColor = RandomColor.secondaryWhite
    
    passwordSegmentedControl.insertSegment(withTitle: appearance.generatePassword,
                                           at: appearance.passwordIndex,
                                           animated: false)
    passwordSegmentedControl.insertSegment(withTitle: appearance.phrasePassword,
                                           at: appearance.phraseIndex,
                                           animated: false)
    passwordSegmentedControl.selectedSegmentIndex = appearance.passwordIndex
    passwordSegmentedControl.addTarget(self, action: #selector(passwordSegmentedControlAction), for: .valueChanged)
    
    phrasePasswordView.isHidden = true
    
    genarateButton.setTitle(appearance.setTextButton, for: .normal)
    genarateButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
    genarateButton.addTarget(self, action: #selector(genarateButtonAction), for: .touchUpInside)
  }
  
  @objc private func passwordSegmentedControlAction() {
    if passwordSegmentedControl.selectedSegmentIndex == Appearance().passwordIndex {
      passwordGeneratorView.isHidden = false
      phrasePasswordView.isHidden = true
    } else {
      passwordGeneratorView.isHidden = true
      phrasePasswordView.isHidden = false
    }
  }
  
  @objc private func genarateButtonAction() {}
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [passwordSegmentedControl, passwordGeneratorView,
     phrasePasswordView, genarateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      passwordSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                        constant: appearance.middleHorizontalSpacing),
      passwordSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                         constant: -appearance.middleHorizontalSpacing),
      passwordSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      passwordGeneratorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      passwordGeneratorView.trailingAnchor.constraint(equalTo: trailingAnchor),
      passwordGeneratorView.topAnchor.constraint(equalTo: passwordSegmentedControl.bottomAnchor,
                                                 constant: appearance.minVerticalInset),
      passwordGeneratorView.bottomAnchor.constraint(equalTo: genarateButton.topAnchor,
                                                    constant: -appearance.minVerticalInset),
      
      phrasePasswordView.leadingAnchor.constraint(equalTo: leadingAnchor),
      phrasePasswordView.trailingAnchor.constraint(equalTo: trailingAnchor),
      phrasePasswordView.topAnchor.constraint(equalTo: passwordSegmentedControl.bottomAnchor,
                                              constant: appearance.minVerticalInset),
      phrasePasswordView.bottomAnchor.constraint(equalTo: genarateButton.topAnchor,
                                                 constant: -appearance.minVerticalInset),
      
      genarateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      genarateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSpacing),
      genarateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSpacing),
      genarateButton.heightAnchor.constraint(equalToConstant: 52)
    ])
  }
}

// MARK: - Appearance

private extension PasswordScreenView {
  struct Appearance {
    let setTextButton = NSLocalizedString("Сгенерировать", comment: "")
    let generatePassword = NSLocalizedString("Генератор паролей", comment: "")
    let phrasePassword = NSLocalizedString("Фраза пароль", comment: "")
    let middleHorizontalSpacing: CGFloat = 16
    let minVerticalInset: CGFloat = 8
    let passwordIndex: Int = 0
    let phraseIndex: Int = 1
  }
}
