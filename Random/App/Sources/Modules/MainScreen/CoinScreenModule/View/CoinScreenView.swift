//
//  CoinScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

protocol CoinScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации
  func playHapticFeedbackAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
  
  /// Сохранить данные
  ///  - Parameter model: результат генерации
  func saveData(model: CoinScreenModel)
  
  /// Была нажата кнопку генерации
  func generateButtonAction()
}

protocol CoinScreenViewInput {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: CoinScreenModel)
  
  /// Показать список генераций результатов
  /// - Parameter isShow: показать  список генераций результатов
  func listGenerated(isShow: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

typealias CoinScreenViewProtocol = UIView & CoinScreenViewInput

final class CoinScreenView: CoinScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let scrollResult = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  private let coinView = CoinView()
  
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
  }
  
  func listGenerated(isShow: Bool) {
    scrollResult.isHidden = !isShow
    resultLabel.isHidden = !isShow
  }
  
  func cleanButtonAction() {
    resultLabel.text = ""
  }
}

// MARK: - Private

private extension CoinScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    scrollResult.backgroundColor = .clear
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = fancyFont.primaryBold50
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
    
    coinView.totalValueCoinAction = { [weak self] coinResultType in
      guard let self else {
        return
      }
      
      let coinResultText = coinResultType == .eagle ? RandomStrings.Localizable.eagle : RandomStrings.Localizable.tails
      self.resultLabel.text = coinResultText
      self.scrollResult.listLabels.insert(coinResultText, at: .zero)
      self.output?.saveData(model: CoinScreenModel(
        result: coinResultText,
        isShowlistGenerated: !self.scrollResult.isHidden,
        coinType: coinResultType,
        listResult: self.scrollResult.listLabels.compactMap({ $0 }))
      )
    }
    
    coinView.feedbackGeneratorAction = { [weak self] in
      self?.output?.playHapticFeedbackAction()
    }
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [coinView, resultLabel, generateButton, scrollResult].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                       constant: appearance.minInset),
      
      coinView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      coinView.leadingAnchor.constraint(equalTo: leadingAnchor),
      coinView.trailingAnchor.constraint(equalTo: trailingAnchor),
      coinView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
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
    output?.playHapticFeedbackAction()
    output?.generateButtonAction()
    resultLabel.text = ""
    coinView.handleTap()
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
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
    
    let buttonTitle = RandomStrings.Localizable.generate
    let eagleImage = RandomAsset.coinEagle.image
    let tailsImage = RandomAsset.coinTails.image
  }
}
