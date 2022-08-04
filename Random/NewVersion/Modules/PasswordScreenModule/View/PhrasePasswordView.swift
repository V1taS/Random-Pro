//
//  PhrasePasswordView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

/// View для экрана
final class PhrasePasswordView: UIView {
    
    // MARK: - Public properties
    
    // MARK: - Internal properties
    
    // MARK: - Private properties
  
  private let phraseLabel = UILabel()
  private let phraseTextField = UITextField()
  private let passwordLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        applyDefaultBehavior()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public func
    
    // MARK: - Internal func
    
    // MARK: - Private func
    
    private func configureLayout() {
      
      [phraseLabel, phraseTextField, passwordLabel ].forEach {
        $0.translatesAutoresizingMaskIntoConstraints = false
        addSubview($0)
      }
      
      NSLayoutConstraint.activate([
        phraseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        phraseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        
        phraseTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        phraseTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        phraseTextField.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor, constant: 16),
        
        passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        passwordLabel.topAnchor.constraint(equalTo: phraseTextField.bottomAnchor, constant: 16)
    ])
    }
    
    private func applyDefaultBehavior() {
      backgroundColor = RandomColor.secondaryWhite
      
      phraseLabel.text = "Фраза"
      phraseLabel.font = RandomFont.primaryBold18
      phraseLabel.textColor = RandomColor.primaryGray
      
      phraseTextField.placeholder = "Введите фразу"
      phraseTextField.delegate = self
      
      passwordLabel.text = "Полученный пароль"
      passwordLabel.font = RandomFont.primaryBold18
      passwordLabel.textColor = RandomColor.primaryGray
    }
}

extension PhrasePasswordView: UITextFieldDelegate {
  
}

// MARK: - Appearance

private extension PhrasePasswordView {
    struct Appearance {
        
    }
}
