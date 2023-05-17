//
//  NickNameScreenView.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol NickNameScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку и происходит генерация 'Коротких никнеймов'
  func generateShortButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Популярных никнеймов'
  func generatePopularButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol NickNameScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: String?)
}

/// Псевдоним протокола UIView & NickNameScreenViewInput
typealias NickNameScreenViewProtocol = UIView & NickNameScreenViewInput

/// View для экрана
final class NickNameScreenView: NickNameScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let inscriptionsSegmentedControl = UISegmentedControl()
  private let generateButton = ButtonView()
  
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
  
  func set(result: String?) {
    resultLabel.text = result
  }
}

// MARK: - Private

private extension NickNameScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [resultLabel, inscriptionsSegmentedControl, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      inscriptionsSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      inscriptionsSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      inscriptionsSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.text = "?"
    
    inscriptionsSegmentedControl.insertSegment(withTitle: appearance.shortTitle,
                                         at: appearance.shortTitleIndex, animated: false)
    inscriptionsSegmentedControl.insertSegment(withTitle: appearance.popularTitle,
                                         at: appearance.popularTitleIndex, animated: false)
    inscriptionsSegmentedControl.selectedSegmentIndex = appearance.shortTitleIndex
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc func generateButtonAction() {
    let appearance = Appearance()
    
    if inscriptionsSegmentedControl.selectedSegmentIndex == appearance.shortTitleIndex {
      output?.generateShortButtonAction()
      return
    }
    
    if inscriptionsSegmentedControl.selectedSegmentIndex == appearance.popularTitleIndex {
      output?.generatePopularButtonAction()
      return
    }
  }
}

// MARK: - Appearance

private extension NickNameScreenView {
  struct Appearance {
    let shortTitle = "Короткий"
    let shortTitleIndex = 0
    let popularTitle = "Популярный"
    let popularTitleIndex = 1
    let buttonTitle = "Сгенерировать"
  }
}
