//
//  ColorsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ColorsScreenViewOutput: AnyObject {
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String)
  
  /// Активировать кнопку копирования
  ///  - Parameter enabled: Состояние кнопки
  func setCopyButtonEnabled(enabled: Bool)
}

/// События которые отправляем от Presenter ко View
protocol ColorsScreenViewInput {
  
  /// Вернуть изображение с цветом
  func returnImageDataColor() -> Data?
  
  /// Скопировать результат генерации
  func copyResult()
}

/// Псевдоним протокола UIView & ColorsScreenViewInput
typealias ColorsScreenViewProtocol = UIView & ColorsScreenViewInput

/// View для экрана
final class ColorsScreenView: ColorsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ColorsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let colorsSegmentedControl = UISegmentedControl(items: Appearance().countColors)
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let contentView = GradientView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func returnImageDataColor() -> Data? {
    contentView.asImage?.pngData()
  }
  
  func copyResult() {
    output?.resultLabelAction(text: resultLabel.text ?? Appearance().resultLabelTitle)
  }
}

// MARK: - Private

private extension ColorsScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [contentView, colorsSegmentedControl, resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      colorsSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      colorsSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                  constant: appearance.defaultInset),
      
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.defaultInset),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    showPlugView()
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = appearance.resultLabelNumberOfLines
    resultLabel.text = appearance.resultLabelTitle
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    colorsSegmentedControl.selectedSegmentIndex = .zero
    colorsSegmentedControl.addTarget(self,
                                     action: #selector(colorsSegmentedControlSegmentedControlAction),
                                     for: .valueChanged)
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  func showPlugView() {
    resultLabel.isHidden = false
    UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
      guard let self = self else {
        return
      }
      self.contentView.applyGradient(colors: [RandomColor.darkAndLightTheme.primaryWhite])
    }
  }
  
  func hidePlugViewWith(colors: [UIColor]) {
    resultLabel.isHidden = false
    
    UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
      guard let self = self else {
        return
      }
      
      self.contentView.applyGradient(colors: colors)
    }
  }
  
  @objc
  func generateButtonAction() {
    let colorOne = UIColor(red: CGFloat.random(in: 0...1),
                           green: CGFloat.random(in: 0...1),
                           blue: CGFloat.random(in: 0...1),
                           alpha: 1)
    let colorTwo = UIColor(red: CGFloat.random(in: 0...1),
                           green: CGFloat.random(in: 0...1),
                           blue: CGFloat.random(in: 0...1),
                           alpha: 1)
    let colorThree = UIColor(red: CGFloat.random(in: 0...1),
                             green: CGFloat.random(in: 0...1),
                             blue: CGFloat.random(in: 0...1),
                             alpha: 1)
    
    if colorsSegmentedControl.selectedSegmentIndex == .zero {
      hidePlugViewWith(colors: [
        colorOne,
        colorTwo,
        colorThree
      ])
      updateResultText(text: convertToHex(colors: [
        colorOne,
        colorTwo,
        colorThree
      ]))
    } else {
      hidePlugViewWith(colors: [colorOne, colorOne])
      updateResultText(text: convertToHex(colors: [
        colorOne
      ]))
    }
  }
  
  func updateResultText(text: String) {
    resultLabel.text = text
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.only.primaryWhite
    let isEnabled = (resultLabel.text != Appearance().resultLabelTitle)
    output?.setCopyButtonEnabled(enabled: isEnabled)
  }
  
  @objc
  func colorsSegmentedControlSegmentedControlAction() {}
  
  @objc
  func resultAction() {
    output?.resultLabelAction(text: resultLabel.text ?? Appearance().resultLabelTitle)
  }
}

// MARK: - Appearance

private extension ColorsScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let minInset: CGFloat = 8
    let midInset: CGFloat = 16
    let maxInset: CGFloat = 24
    let resultLabelNumberOfLines = 0
    let resultDuration: CGFloat = 0.2
    
    let resultLabelTitle = "?"
    let buttonTitle = RandomStrings.Localizable.generate
    let countColors = [
      RandomStrings.Localizable.gradient,
      RandomStrings.Localizable.regular
    ]
  }
}
