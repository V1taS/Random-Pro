//
//  ColorsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol ColorsScreenViewOutput: AnyObject {
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
  
  /// Была нажата кнопка сгенерировать результат
  ///  - Parameter text: Результат генерации
  func generateResultButtonPressed(text: String?)
}

/// События которые отправляем от Presenter ко View
protocol ColorsScreenViewInput {
  
  /// Вернуть изображение с цветом
  func returnImageDataColor() -> Data?
  
  /// Вернуть результат генерации
  func getResult() -> String?
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
  
  func getResult() -> String? {
    return resultLabel.text
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
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    showPlugView()
    
    resultLabel.font = fancyFont.primaryBold70
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = appearance.resultLabelNumberOfLines
    resultLabel.text = appearance.resultLabelTitle
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    colorsSegmentedControl.selectedSegmentIndex = .zero
    colorsSegmentedControl.addTarget(self,
                                     action: #selector(colorsSegmentedControlSegmentedControlAction),
                                     for: .valueChanged)
    
    let resultLabelGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(resultAction))
    resultLabelGestureRecognizer.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelGestureRecognizer)
    resultLabel.isUserInteractionEnabled = true
  }
  
  func showPlugView() {
    UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
      guard let self = self else {
        return
      }
      self.contentView.applyGradient(colors: [fancyColor.darkAndLightTheme.primaryWhite])
    }
  }
  
  func hidePlugViewWith(colors: [UIColor]) {
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
    output?.generateResultButtonPressed(text: resultLabel.text)
  }
  
  func updateResultText(text: String) {
    resultLabel.text = text
    resultLabel.font = fancyFont.primaryBold50
    resultLabel.textColor = fancyColor.only.primaryWhite
  }
  
  @objc
  func colorsSegmentedControlSegmentedControlAction() {}
  
  @objc
  func resultAction() {
    output?.resultLabelAction(text: resultLabel.text)
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
