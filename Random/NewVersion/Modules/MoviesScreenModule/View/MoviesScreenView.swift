//
//  MoviesScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol MoviesScreenViewOutput: AnyObject {}

protocol MoviesScreenViewInput {}

typealias MoviesScreenViewProtocol = UIView & MoviesScreenViewInput

final class MoviesScreenView: MoviesScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: MoviesScreenViewOutput?
  
  // MARK: - Private property
  
  private let moviesSegmentedControl = UISegmentedControl()
  private let moviesImageScreenView = MoviesImageScreenView()
  private let genarateButton = ButtonView()
  private let advLabel = LabelGradientView()
  
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
    
    moviesSegmentedControl.insertSegment(withTitle: appearance.bestText,
                                         at: appearance.bestIndex,
                                         animated: false)
    moviesSegmentedControl.insertSegment(withTitle: appearance.popularText,
                                         at: appearance.popularIndex,
                                         animated: false)
    moviesSegmentedControl.selectedSegmentIndex = appearance.bestIndex
    moviesSegmentedControl.addTarget(self, action: #selector(moviesSegmentedControlAction), for: .valueChanged)
    
    genarateButton.setTitle(appearance.setTextButton, for: .normal)
    genarateButton.addTarget(self, action: #selector(genarateButtonAction), for: .touchUpInside)
  }
  
  @objc private func moviesSegmentedControlAction() {}
  
  @objc private func genarateButtonAction() {}
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [moviesSegmentedControl, moviesImageScreenView, genarateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
        
    NSLayoutConstraint.activate([
      moviesSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: appearance.middleSpacing),
      moviesSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -appearance.middleSpacing),
      moviesSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

      moviesImageScreenView.leadingAnchor.constraint(equalTo: leadingAnchor),
      moviesImageScreenView.trailingAnchor.constraint(equalTo: trailingAnchor),
      moviesImageScreenView.topAnchor.constraint(equalTo: moviesSegmentedControl.bottomAnchor,
                                                 constant: appearance.minInset),
      moviesImageScreenView.bottomAnchor.constraint(equalTo: genarateButton.topAnchor,
                                                    constant: appearance.minInset),
      
      genarateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleSpacing),
      genarateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleSpacing),
      genarateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleSpacing)
    
    ])
  }
}

// MARK: - Appearance

extension MoviesScreenView {
  struct Appearance {
    let bestIndex: Int = 0
    let popularIndex: Int = 1
    let bestText = NSLocalizedString("250 Лучших", comment: "")
    let popularText = NSLocalizedString("100 Популярных", comment: "")
    let setTextButton = NSLocalizedString("Сгенерировать", comment: "")
    let middleSpacing: CGFloat = 16
    let minInset: CGFloat = 8
  }
}
