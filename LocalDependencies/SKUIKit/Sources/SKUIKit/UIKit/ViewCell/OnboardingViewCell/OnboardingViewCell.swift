//
//  OnboardingViewCell.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

// MARK: - OnboardingViewCell

public final class OnboardingViewCell: UITableViewCell {
  
  // MARK: - Public properties
  
  /// Identifier для ячейки
  public static let reuseIdentifier = OnboardingViewCell.description()
  
  // MARK: - Private properties
  
  private let onboardingView = OnboardingView()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameter model: Моделька с данными
  public func configureCellWith(_ model: OnboardingViewModel) {
    onboardingView.setOnboardingWith(model)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [onboardingView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      onboardingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: appearance.defaultInsets),
      onboardingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -appearance.defaultInsets),
      onboardingView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: appearance.minInset),
      onboardingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    contentView.backgroundColor = SKStyleAsset.onyx.color
    selectionStyle = .none
  }
}

// MARK: - Appearance

private extension OnboardingViewCell {
  struct Appearance {
    let minInset: CGFloat = 4
    let defaultInsets: CGFloat = 16
  }
}

