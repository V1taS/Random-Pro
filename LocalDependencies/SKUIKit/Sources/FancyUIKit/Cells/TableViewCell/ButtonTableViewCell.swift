//
//  ButtonTableViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyStyle

// MARK: - ButtonTableViewCell

public final class ButtonTableViewCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = ButtonTableViewCell.description()
  
  // MARK: - Private properties
  
  private let buttonView = ButtonView()
  
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
  /// - Parameter completion: Возвращает кнопку
  public func configureCellWith(completion: ((ButtonView) -> Void)?) {
    completion?(buttonView)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [buttonView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      buttonView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: appearance.minInset),
      buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                         constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
  }
}

// MARK: - Appearance

private extension ButtonTableViewCell {
  struct Appearance {
    let minInset: CGFloat = 4
    let defaultInset: CGFloat = 16
  }
}
