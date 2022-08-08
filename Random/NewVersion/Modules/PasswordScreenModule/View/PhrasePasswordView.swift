//
//  PhrasePasswordView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

final class PhrasePasswordView: UIView {
  
  // MARK: - Private properties
  
  private let phraseLabel = UILabel()
  private let phraseTextField = UITextField()
  private let passwordLabel = UILabel()
  private let resultLabel = UILabel()
  private let charactersCountLabel = UILabel()
  private let frameUnderTextFieldView = UIView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [phraseLabel, passwordLabel, resultLabel, frameUnderTextFieldView, phraseTextField, charactersCountLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [phraseTextField, charactersCountLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      frameUnderTextFieldView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      phraseLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.mediumSpasing),
      phraseLabel.topAnchor.constraint(equalTo: topAnchor,
                                       constant: appearance.mediumSpasing),
      phraseLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.mediumSpasing),
      
      frameUnderTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: appearance.mediumSpasing),
      frameUnderTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                          constant: -appearance.mediumSpasing),
      frameUnderTextFieldView.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor,
                                     constant: appearance.mediumSpasing),
      frameUnderTextFieldView.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor,
                                        constant: -appearance.mediumSpasing),
      
      phraseTextField.leadingAnchor.constraint(equalTo: frameUnderTextFieldView.leadingAnchor,
                                               constant: appearance.horizontalSpasing),
      phraseTextField.trailingAnchor.constraint(equalTo: frameUnderTextFieldView.trailingAnchor,
                                                constant: -appearance.midleSpasing),
      phraseTextField.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor,
                                           constant: appearance.mediumSpasing),
      phraseTextField.heightAnchor.constraint(equalToConstant: appearance.heightSpasing),
      
      passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: appearance.mediumSpasing),
      passwordLabel.topAnchor.constraint(equalTo: phraseTextField.bottomAnchor,
                                         constant: appearance.mediumSpasing),
      passwordLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -appearance.mediumSpasing),
      
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.mediumSpasing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.mediumSpasing),
      resultLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor,
                                       constant: appearance.horizontalSpasing),
      
      charactersCountLabel.leadingAnchor.constraint(equalTo: phraseTextField.trailingAnchor,
                                               constant: appearance.lessSpasing),
      charactersCountLabel.trailingAnchor.constraint(equalTo: frameUnderTextFieldView.trailingAnchor,
                                                constant: -appearance.mediumSpasing),
      charactersCountLabel.topAnchor.constraint(equalTo: frameUnderTextFieldView.topAnchor,
                                           constant: appearance.mediumSpasing)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.secondaryWhite
    
    phraseLabel.text = appearance.phrase + ":"
    phraseLabel.font = RandomFont.primaryBold18
    phraseLabel.textColor = RandomColor.primaryGray
    phraseLabel.textAlignment = .center
    
    frameUnderTextFieldView.backgroundColor = .white
    frameUnderTextFieldView.layer.borderWidth = appearance.width
    frameUnderTextFieldView.layer.cornerRadius = appearance.mediumSpasing
    
    phraseTextField.placeholder = appearance.enterPhase + ":"
    phraseTextField.delegate = self
    phraseTextField.textColor = RandomColor.primaryGray
    
    passwordLabel.text = appearance.getPassword + ":"
    passwordLabel.font = RandomFont.primaryBold18
    passwordLabel.textColor = RandomColor.primaryGray
    passwordLabel.textAlignment = .center
    
    resultLabel.textAlignment = .center
    resultLabel.text = appearance.result
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.primaryGray
    
    charactersCountLabel.text = appearance.numbers
    charactersCountLabel.font = RandomFont.primaryRegular18
    charactersCountLabel.textColor = RandomColor.primaryGray
  }
}

// MARK: - UITextFieldDelegate

extension PhrasePasswordView: UITextFieldDelegate {}

// MARK: - Appearance

private extension PhrasePasswordView {
  struct Appearance {
    let phrase = NSLocalizedString("Фраза", comment: "")
    let enterPhase = NSLocalizedString("Введите фразу", comment: "")
    let getPassword = NSLocalizedString("Полученный пароль", comment: "")
    let result = "?"
    let numbers = "0"
    let width: CGFloat = 0.5
    let mediumSpasing: CGFloat = 16
    let lessSpasing: CGFloat = 8
    let horizontalSpasing: CGFloat = 24
    let midleSpasing: CGFloat = 40
    let heightSpasing: CGFloat = 48
  }
}
