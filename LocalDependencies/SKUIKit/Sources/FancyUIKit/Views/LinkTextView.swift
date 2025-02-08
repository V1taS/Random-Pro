//
//  LinkTextView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import FancyStyle

/// Доступные для касания «ссылки» в NSAttributedString UITextView
public final class LinkTextView: UITextView {
  
  // MARK: - Public variables
  
  /// Действие по LinkTap `Вызывается при переходе по ссылке в тексте`
  /// - Parameters:
  ///  - URL: возвращает URL ссылки, на которую нажали
  ///  - completion: Разрешает взаимодействие пользователя с указанным URL-адресом. Например: отключить открывающиеся ссылки и обработать клик здесь `return false`
  public var actionLinkTap: ((URL) -> Bool)?
  
  /// Цвет текста ссылки. Цвет по умолчанию`primaryBlue`
  public var linkColor: UIColor = .fancy.only.primaryBlue {
    didSet {
      configureStyleTextLink(linkColor: linkColor)
    }
  }
  
  /// Полный цвет текста. Цвет по умолчанию`primaryGray`
  public var defaultTextColor: UIColor? = .fancy.darkAndLightTheme.primaryGray {
    didSet {
      textColor = defaultTextColor
    }
  }
  
  /// Полнотекстовый шрифт. Шрифт по умолчанию`primaryMedium14`
  public var defaultTextFont: UIFont? = fancyFont.primaryMedium14 {
    didSet {
      font = defaultTextFont
    }
  }
  
  /// Полное выравнивание текста. Выравнивание по умолчанию`center`
  public var defaultTextAlignment: NSTextAlignment = .center {
    didSet {
      textAlignment = defaultTextAlignment
    }
  }
  
  // MARK: - Initialization
  
  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    applyDefaultBehavior()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    applyDefaultBehavior()
  }
  
  // MARK: - Public funcs
  
  /// Добавьте ссылки для текста
  /// - Parameters:
  ///   - links: Свяжите словарь с [linkText: url]. Например: `["Общих условиях": "https://какой-то.сайт"]`
  public func addLinks(_ links: [String : String]) {
    guard attributedText.length > .zero else {
      return
    }
    let mutableText = NSMutableAttributedString(attributedString: attributedText)
    
    for (linkText, url) in links {
      if linkText.count > .zero {
        let linkRange = mutableText.mutableString.range(of: linkText)
        mutableText.addAttribute(.link, value: url, range: linkRange)
      }
    }
    
    let style = NSMutableParagraphStyle()
    style.lineHeightMultiple = 1.23
    mutableText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: mutableText.length))
    
    attributedText = mutableText
  }
  
  // MARK: - Private funcs
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    textColor = defaultTextColor
    font = defaultTextFont
    textAlignment = defaultTextAlignment
    
    isEditable = false
    isSelectable = true
    isScrollEnabled = false
    delegate = self
    
    let padding = textContainer.lineFragmentPadding
    textContainerInset = UIEdgeInsets(top: .zero, left: -padding, bottom: .zero, right: -padding)
    
    configureStyleTextLink(linkColor: linkColor)
  }
  
  private func configureStyleTextLink(linkColor: UIColor) {
    linkTextAttributes = [NSAttributedString.Key.foregroundColor: linkColor]
  }
}

// MARK: - UITextViewDelegate

extension LinkTextView: UITextViewDelegate {
  public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    return actionLinkTap?(URL) ?? true
  }
  
  public func textViewDidChangeSelection(_ textView: UITextView) {
    textView.selectedTextRange = nil
  }
}
