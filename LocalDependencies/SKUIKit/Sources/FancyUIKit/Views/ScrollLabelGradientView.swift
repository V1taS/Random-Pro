//
//  ScrollLabelGradientView.swift
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyStyle

/// View для экрана
public final class ScrollLabelGradientView: UIView {
  
  // MARK: - Public properties
  
  /// Список элементов для отображения
  ///  - Parameter listLabels: Массив элементов для отображения в формате `String`
  public var listLabels: [String?] = [] {
    didSet {
      configureSubviewsForStack(listLabels)
    }
  }
  
  public override var intrinsicContentSize: CGSize {
    Appearance().intrinsicContentSize
  }
  
  // MARK: - Private properties
  
  private let scrollView = UIScrollView()
  private let contentStackView = UIStackView()
  private var listViews: [UIView] = []
  
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
    [scrollView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [contentStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
    
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    
    scrollView.keyboardDismissMode = .interactive
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = appearance.insets
    
    contentStackView.axis = .horizontal
    contentStackView.spacing = appearance.spacing
  }
  
  private func configureSubviewsForStack(_ labels: [String?]) {
    contentStackView.removeFullyAllArrangedSubviews()
    
    let labels = listLabels.compactMap { $0 }
    
    labels.enumerated().forEach { index, textLabel in
      if index == .zero {
        let primaryLabel = LabelGradientView()
        primaryLabel.configureWith(titleText: textLabel,
                                   textColor: .fancy.darkAndLightTheme.primaryWhite,
                                   gradientDVLabel: [
                                    .fancy.only.primaryGreen,
                                    .fancy.only.secondaryGreen
                                   ])
        [primaryLabel].forEach {
          $0.translatesAutoresizingMaskIntoConstraints = false
          contentStackView.addArrangedSubview($0)
        }
      } else {
        let secondaryLabel = UILabel()
        secondaryLabel.text = textLabel
        secondaryLabel.textColor = .fancy.darkAndLightTheme.primaryGray
        
        [secondaryLabel].forEach {
          $0.translatesAutoresizingMaskIntoConstraints = false
          contentStackView.addArrangedSubview($0)
        }
      }
    }
  }
}

// MARK: - Appearance

private extension ScrollLabelGradientView {
  struct Appearance {
    let insets = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
    let intrinsicContentSize = CGSize(width: UIView.noIntrinsicMetric, height: 30)
    let spacing: CGFloat = 16
  }
}
