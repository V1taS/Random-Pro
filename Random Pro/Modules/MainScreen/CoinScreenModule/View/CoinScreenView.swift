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

protocol CoinScreenViewInput: AnyObject {
  
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
    resultLabel.text = model.result
    scrollResult.listLabels = model.listResult
    
    if model.coinType != .none {
      let appearance = Appearance()
      let image = model.coinType == .eagle ? appearance.eagle : appearance.tails
      coinImageView.image = image
      UIView.transition(with: coinImageView,
                        duration: Appearance().resulDuration,
                        options: .transitionFlipFromRight,
                        animations: nil,
                        completion: nil)
    } else {
      coinImageView.image = nil
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
    
    generateButton.setTitle(appearance.textButton, for: .normal)
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
                                       constant: appearance.lessVirticalSize),
      
      coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      coinImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      coinImageView.heightAnchor.constraint(equalToConstant: appearance.height),
      coinImageView.widthAnchor.constraint(equalToConstant: appearance.width),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSize),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSize),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSize),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                           constant: -appearance.lessVirticalSize)
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
    let textButton = NSLocalizedString("Сгенерировать", comment: "")
    let cornerRadius: CGFloat = 100
    let middleHorizontalSize: CGFloat = 16
    let hightVirticalSize: CGFloat = 24
    let lessVirticalSize: CGFloat = 8
    let height: CGFloat = 200
    let width: CGFloat = 200
    let resulDuration: CGFloat = 0.5
    
    let eagle = UIImage(named: "coin_eagle") ?? UIImage()
    let tails = UIImage(named: "coin_tails") ?? UIImage()
  }
}
