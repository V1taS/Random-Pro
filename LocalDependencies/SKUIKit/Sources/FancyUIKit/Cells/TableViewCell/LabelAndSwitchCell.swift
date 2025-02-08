//
//  LabelAndSwitchCell.swift
//
//  Created by Tatiana Sosina on 22.05.2022.
//

import UIKit
import FancyStyle

// MARK: - LabelAndSwitchCell

public final class LabelAndSwitchCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Action на изменение переключателя
  public var switchAction: ((Bool) -> Void)?
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LabelAndSwitchCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let resultSwitch = UISwitch()
  
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
  ///  - titleText: Заголовок у ячейки
  ///  - isResultSwitch: Значение у переключателя
  public func configureCellWith(titleText: String?, isResultSwitch: Bool) {
    titleLabel.text = titleText
    resultSwitch.isOn = isResultSwitch
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, resultSwitch].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: appearance.insets.top),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                         constant: -appearance.insets.bottom),
      
      resultSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      resultSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -appearance.insets.right),
      resultSwitch.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: appearance.insets.top),
      resultSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -appearance.insets.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    resultSwitch.addTarget(self, action: #selector(resultSwitchAction(_:)), for: .valueChanged)
    resultSwitch.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  @objc private func resultSwitchAction(_ sender: UISwitch) {
    switchAction?(sender.isOn)
  }
}

// MARK: - Appearance

private extension LabelAndSwitchCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}
