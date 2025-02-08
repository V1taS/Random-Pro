//
//  LabelAndChevronCell.swift
//
//  Created by Tatiana Sosina on 22.05.2022.
//

import UIKit
import FancyStyle

// MARK: - LabelAndChevronCell

public final class LabelAndChevronCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LabelAndChevronCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let chevronImageView = UIImageView()
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
    contentView.backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    impactFeedback.impactOccurred()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - titleText: Заголовок
  public func configureCellWith(titleText: String?) {
    titleLabel.text = titleText
    chevronImageView.image = Appearance().chevronRight
    chevronImageView.setImageColor(color: .fancy.only.primaryBlue)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, chevronImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      chevronImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -appearance.insets.right),
      chevronImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: appearance.insets.top),
      chevronImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -appearance.insets.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    chevronImageView.contentMode = .right
    chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: - Appearance

private extension LabelAndChevronCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 24
    let chevronRight = UIImage(named: "chevron_right", in: .module, compatibleWith: nil)
  }
}
