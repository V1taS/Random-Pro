//
//  EmoticonSelectionView.swift
//
//  Created by Vitalii Sosin on 17.06.2023.
//

import UIKit
import FancyStyle

/// View для экрана
public final class EmoticonSelectionView: UIView {
  
  // MARK: - Style
  
  public enum Style {
    
    /// Выбран
    case selected
    
    /// Не выбран
    case none
  }
  
  // MARK: - Private property
  
  private var actionEmoticon: ((_ emoticon: Character?, _ style: Style) -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private let emoticonTextField = InvisibleCursorTextField()
  private var style: Style = .none {
    didSet {
      layer.borderWidth = 1
      layer.borderColor = style == .selected ? .fancy.only.primaryBlue.cgColor : .fancy.only.secondaryGray.cgColor
    }
  }
  private var dublicateText = ""
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - emoticon: Смайлик
  ///  - actionEmoticon: Действие на смайлик
  public func configureWith(emoticon: Character?,
                            actionEmoticon: ((_ emoticon: Character?, _ style: Style) -> Void)?) {
    if let emoticon {
      emoticonTextField.text = String(emoticon)
    }
    self.actionEmoticon = actionEmoticon
  }
}

// MARK: - Private

private extension EmoticonSelectionView {
  func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    emoticonTextField.textAlignment = .center
    emoticonTextField.font = fancyFont.primaryBold24
    emoticonTextField.isSelected = false
    emoticonTextField.autocorrectionType = .no
    emoticonTextField.smartQuotesType = .no
    emoticonTextField.smartDashesType = .no

    clipsToBounds = true
    layer.cornerRadius = Appearance().cornerRadius
    
    emoticonTextField.delegate = self
    style = .none
  }
  
  func configureLayout() {
    let appearance = Appearance()
    [emoticonTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: appearance.viewSize.width),
      heightAnchor.constraint(equalToConstant: appearance.viewSize.height),
      
      emoticonTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
      emoticonTextField.topAnchor.constraint(equalTo: topAnchor),
      emoticonTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
      emoticonTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

// MARK: - UITextFieldDelegate

extension EmoticonSelectionView: UITextFieldDelegate {
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    style = .selected
    self.zoomIn(duration: Appearance().resultDuration,
                transformScale: CGAffineTransform(scaleX: 0.95, y: 0.95))
    impactFeedback.impactOccurred()
    return true
  }
  
  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    style = .none
    return true
  }
  
  public func textField(_ textField: UITextField,
                        shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
    guard let currentText = textField.text,
          let character = (currentText as NSString).replacingCharacters(in: range, with: string).last,
          dublicateText != String(character) else {
      return false
    }
    
    emoticonTextField.text = String(character)
    actionEmoticon?(Character(extendedGraphemeClusterLiteral: character), style)
    return false
  }
}

// MARK: - Appearance

private extension EmoticonSelectionView {
  struct Appearance {
    let resultDuration: CGFloat = 0.2
    let cornerRadius: CGFloat = 12
    let viewSize = CGSize(width: 44, height: 44)
  }
}
