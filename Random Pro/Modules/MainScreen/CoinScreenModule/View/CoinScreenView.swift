//
//  CoinScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol CoinScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()
}

protocol CoinScreenViewInput {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: CoinScreenModel)
}

typealias CoinScreenViewProtocol = UIView & CoinScreenViewInput

final class CoinScreenView: CoinScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let scrollResult = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  private let coinImageView = UIImageView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: CoinScreenModel) {
    scrollResult.listLabels = model.listResult
    
    if model.coinType != .none {
      let appearance = Appearance()
      let image = model.coinType == .eagle ? appearance.eagleImage : appearance.tailsImage
      coinImageView.image = image
      UIView.transition(with: coinImageView,
                        duration: Appearance().resultDuration,
                        options: .transitionFlipFromRight,
                        animations: nil,
                        completion: { [weak self] _ in
        guard let self = self else {
          return
        }
        self.resultLabel.text = model.result
      })
    } else {
      coinImageView.image = nil
      resultLabel.text = model.result
    }
  }
}

// MARK: - Private

private extension CoinScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.primaryGray
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    coinImageView.layer.cornerRadius = appearance.cornerRadius
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, generateButton, coinImageView, scrollResult].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                       constant: appearance.minInset),
      
      coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      coinImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      coinImageView.heightAnchor.constraint(equalToConstant: appearance.heightCoinImage),
      coinImageView.widthAnchor.constraint(equalToConstant: appearance.widthCoinImage),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
}

// MARK: - Appearance

private extension CoinScreenView {
  struct Appearance {
    let cornerRadius: CGFloat = 100
    
    let defaultInset: CGFloat = 16
    let minInset: CGFloat = 8
    
    let heightCoinImage: CGFloat = 200
    let widthCoinImage: CGFloat = 200
    let resultDuration: CGFloat = 0.5
    
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
    let eagleImage = UIImage(named: "coin_eagle") ?? UIImage()
    let tailsImage = UIImage(named: "coin_tails") ?? UIImage()
  }
}
