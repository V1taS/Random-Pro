//
//  PurchasesCardView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

/// View для экрана
public final class PurchasesCardView: UIView {
  
  // MARK: - Public property
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: Appearance().widthCard, height: UIView.noIntrinsicMetric)
  }
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // MARK: - Private property
  
  private let containerView = GradientView()
  private let headerTitleLabel = UILabel()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let amountLabel = UILabel()
  private var action: (() -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    guard let action else {
      return
    }
    impactFeedback.impactOccurred()
    action()
    self.zoomInWithEasing()
  }

  /// Настраиваем Вью
  /// - Parameters:
  ///  - header: Тайтл в заголовке
  ///  - title: Тайтл
  ///  - description: Описание
  ///  - amount: Сумма
  ///  - isSelected: Выьрана карточка
  ///  - action: экшен
  public func configureWith(header: String?,
                            title: String?,
                            description: String?,
                            amount: String?,
                            isSelected: Bool,
                            action: (() -> Void)?) {
    self.action = action
    headerTitleLabel.text = header
    titleLabel.text = title
    descriptionLabel.text = description
    amountLabel.text = amount ?? "-"
    setIsSelected(isSelected)
  }
  
  /// Устатовить состояние карточки
  /// - Parameter isSelected: Карточка выбрана
  public func setIsSelected(_ isSelected: Bool) {
    let appearance = Appearance()
    
    headerTitleLabel.isHidden = !isSelected
    
    if isSelected {
      layer.borderColor = SKStyleAsset.constantSlate.color.cgColor
      layer.borderWidth = appearance.borderWidth
      
      containerView.applyGradient(colors:  [
        SKStyleAsset.constantNavy.color,
        SKStyleAsset.constantNavy.color
      ])
      
      applyGradient(colors: [SKStyleAsset.constantAzure.color,
                             SKStyleAsset.constantAzure.color.withAlphaComponent(0.8)])
      
      titleLabel.textColor = SKStyleAsset.onyx.color
      descriptionLabel.textColor = SKStyleAsset.onyx.color
      amountLabel.textColor = SKStyleAsset.onyx.color
    } else {
      containerView.applyGradient(colors:  [
        SKStyleAsset.onyx.color,
        SKStyleAsset.onyx.color
      ])
      layer.borderWidth = .zero
      
      applyGradient(colors: [SKStyleAsset.onyx.color,
                             SKStyleAsset.onyx.color])
      
      titleLabel.textColor = SKStyleAsset.constantSlate.color
      descriptionLabel.textColor = SKStyleAsset.constantSlate.color
      amountLabel.textColor = SKStyleAsset.constantSlate.color
    }
  }
}

// MARK: - Appearance

private extension PurchasesCardView {
  func configureLayout() {
    let appearance = Appearance()
    
    [headerTitleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview($0)
    }
    
    [containerView, titleLabel, descriptionLabel, amountLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      containerView.heightAnchor.constraint(equalToConstant: appearance.containerHeight),
      
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      headerTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      headerTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: appearance.midInset),
      headerTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -appearance.midInset),
      
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: appearance.minInset),
      titleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor,
                                      constant: appearance.minInset),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -appearance.minInset),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.minInset),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: appearance.minInset),
      descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.minInset),
      
      amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.minInset),
      amountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                       constant: appearance.minInset),
      amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                          constant: -appearance.midInset),
      amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.minInset)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    headerTitleLabel.textAlignment = .center
    headerTitleLabel.font = .fancy.text.regularMedium
    headerTitleLabel.textColor = SKStyleAsset.constantGhost.color
    headerTitleLabel.numberOfLines = appearance.numberOfLines
    
    titleLabel.textAlignment = .center
    titleLabel.font = .fancy.text.largeTitle
    titleLabel.textColor = SKStyleAsset.onyx.color
    titleLabel.numberOfLines = appearance.numberOfLines
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = .fancy.text.regular
    descriptionLabel.textColor = SKStyleAsset.onyx.color
    descriptionLabel.numberOfLines = appearance.numberOfLines
    descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    
    amountLabel.textAlignment = .center
    amountLabel.font = .fancy.text.title
    amountLabel.textColor = SKStyleAsset.onyx.color
    amountLabel.numberOfLines = appearance.numberOfLines
    amountLabel.setContentHuggingPriority(.required, for: .vertical)
    
    clipsToBounds = true
    layer.cornerRadius = appearance.cornerRadius
  }
  
  private func applyGradient(colors: [UIColor], alpha: CGFloat = 1) {
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map { $0.withAlphaComponent(alpha).cgColor }
  }
}

// MARK: - Appearance

private extension PurchasesCardView {
  struct Appearance {
    let cornerRadius: CGFloat = 16
    let borderWidth: CGFloat = 1
    let widthCard: CGFloat = 129
    let minInset: CGFloat = 4
    let midInset: CGFloat = 8
    let containerHeight: CGFloat = 50
    let numberOfLines = 2
  }
}

