//
//  SmallButtonCell.swift
//
//  Created by Tatiana Sosina on 22.05.2022.
//

import UIKit
import FancyStyle

// MARK: - SmallButtonCell

public final class SmallButtonCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Акшен по нажатию на кнопку
  public var action: (() -> Void)?
  
  /// Identifier для ячейки
  public static let reuseIdentifier = SmallButtonCell.description()
  
  // MARK: - Private property
  
  private let button = SmallButtonView()
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
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - titleButton: Название кнопки
  ///  - color: Цвет названия у кнопки
  public func configureCellWith(titleButton: String?, color: UIColor? = nil) {
    button.setTitle(titleButton, for: .normal)
    
    if let color = color {
      button.setTitleColor(color, for: .normal)
    }
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [button].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                      constant: appearance.insets.left),
      button.topAnchor.constraint(equalTo: contentView.topAnchor,
                                  constant: appearance.insets.top),
      button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                       constant: -appearance.insets.right),
      button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                     constant: -appearance.insets.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    button.titleLabel?.font = fancyFont.primaryRegular18
    button.setTitleColor(.fancy.only.primaryBlue, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
  }
  
  @objc private func buttonAction() {
    action?()
  }
}

// MARK: - Appearance

private extension SmallButtonCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}
