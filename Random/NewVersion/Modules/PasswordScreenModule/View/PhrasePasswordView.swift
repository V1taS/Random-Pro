//
//  PhrasePasswordView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

final class PhrasePasswordView: UIView {
  
  // MARK: - Internal properties
  
  let resultTextView = UITextView()
  let phraseTextField = UITextField()
  var resultTextAction: (() -> Void)?
  
  // MARK: - Private properties
  
  private let phraseLabel = UILabel()
  private let passwordLabel = UILabel()
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
    
    [phraseLabel, passwordLabel, resultTextView, frameUnderTextFieldView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [phraseTextField].forEach {
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
                                               constant: appearance.lessSpasing),
      phraseTextField.trailingAnchor.constraint(equalTo: frameUnderTextFieldView.trailingAnchor,
                                                constant: -appearance.lessSpasing),
      phraseTextField.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor,
                                           constant: appearance.mediumSpasing),
      phraseTextField.heightAnchor.constraint(equalToConstant: appearance.heightSpasing),
      
      passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: appearance.mediumSpasing),
      passwordLabel.topAnchor.constraint(equalTo: phraseTextField.bottomAnchor,
                                         constant: appearance.mediumSpasing),
      passwordLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -appearance.mediumSpasing),
      
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.mediumSpasing),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.mediumSpasing),
      resultTextView.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor,
                                       constant: appearance.horizontalSpasing),
      resultTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
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
    
    resultTextView.textColor = RandomColor.primaryGray
    resultTextView.font = RandomFont.primaryMedium24
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false

    let padding = resultTextView.textContainer.lineFragmentPadding
    resultTextView.textContainerInset =  UIEdgeInsets(top: .zero,
                                                      left: -padding,
                                                      bottom: .zero,
                                                      right: -padding)
    
    let resultTextTap = UITapGestureRecognizer(target: self, action: #selector(resultTextTapAction))
    resultTextTap.cancelsTouchesInView = false
    resultTextView.addGestureRecognizer(resultTextTap)
    resultTextView.isUserInteractionEnabled = true
  }
  
  @objc
  private func resultTextTapAction() {
    resultTextAction?()
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
    let numbers = "0"
    let width: CGFloat = 0.5
    let mediumSpasing: CGFloat = 16
    let lessSpasing: CGFloat = 8
    let horizontalSpasing: CGFloat = 24
    let midleSpasing: CGFloat = 40
    let heightSpasing: CGFloat = 48
  }
}
