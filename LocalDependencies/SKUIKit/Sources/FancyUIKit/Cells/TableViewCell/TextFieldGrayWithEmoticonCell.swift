//
//  TextFieldGrayWithEmoticonCell.swift
//  
//
//  Created by Vitalii Sosin on 17.06.2023.
//

import UIKit
import FancyStyle

// MARK: - TextFieldGrayWithEmoticonCell

public final class TextFieldGrayWithEmoticonCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = TextFieldGrayWithEmoticonCell.description()
  
  // MARK: - Private property
  
  private var textField: TextFieldView?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private let emoticonSelectionView = EmoticonSelectionView()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - textField: Текстовое поле
  ///  - textFieldBorderColor: Цвет оконтовки
  ///  - emoticon: Смайлик
  ///  - actionEmoticon: Действие на смайлик
  public func configureCellWith(textField: TextFieldView,
                                textFieldBorderColor: UIColor? = nil,
                                emoticon: Character?,
                                actionEmoticon: ((_ emoticon: Character?,
                                                  _ style: EmoticonSelectionView.Style) -> Void)?) {
    self.textField = textField
    textField.font = fancyFont.primaryMedium18
    textField.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    emoticonSelectionView.configureWith(emoticon: emoticon, actionEmoticon: actionEmoticon)
    if let textFieldBorderColor = textFieldBorderColor {
      self.textField?.layer.borderColor = textFieldBorderColor.cgColor
    }
    configureLayout(textField: textField)
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout(textField: TextFieldView) {
    let appearance = Appearance()
    
    [emoticonSelectionView, textField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      emoticonSelectionView.widthAnchor.constraint(equalToConstant: appearance.buttonSize.width),
      emoticonSelectionView.heightAnchor.constraint(equalToConstant: appearance.buttonSize.height),
      textField.heightAnchor.constraint(equalToConstant: appearance.buttonSize.height),
      
      
      emoticonSelectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      emoticonSelectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: appearance.insets.left),
      emoticonSelectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      textField.leadingAnchor.constraint(equalTo: emoticonSelectionView.trailingAnchor,
                                         constant: appearance.insets.left),
      textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                          constant: -appearance.insets.left),
      textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
  }
}

// MARK: - Appearance

private extension TextFieldGrayWithEmoticonCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let buttonSize = CGSize(width: 44, height: 44)
    let resultDuration: CGFloat = 0.2
  }
}
