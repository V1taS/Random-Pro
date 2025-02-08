//
//  LinkTextViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import FancyStyle

// MARK: - LinkTextViewCell

public final class LinkTextViewCell: UITableViewCell {
  
  // MARK: - Public properties
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LinkTextViewCell.description()
  
  // MARK: - Private properties
  
  private let linkTextView = LinkTextView()
  
  
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
  
  /// Сконфигурировать ячейку
  /// - Parameters:
  ///   - fullText: Полный текст условий обслуживания. Например: `[Подтверждаете ознакомление с Общими условиями.]`
  ///   - fullTextColor: Полный цвет текста
  ///   - fullTextFont: Полнотекстовый шрифт
  ///   - fullTextAlignment: Полное выравнивание текста.
  ///   - links: Свяжите словарь с [linkText: url] Например: `["Общими условиями": "https://Сайт.ру"]`
  ///   - linkColor: Цвет текста ссылки.
  ///   - actionLinkTap: `Получить` URL ссылки, по которой щелкнули. `Returns`: позволяет пользователю взаимодействовать с указанным URL-адресом. Например: отключить открывающиеся ссылки и обработать клик здесь `return false`
  public func configureCellWith(
    fullText: String?,
    fullTextColor: UIColor?,
    fullTextFont: UIFont?,
    fullTextAlignment: NSTextAlignment?,
    links: [String: String],
    linkColor: UIColor?,
    actionLinkTap: ((URL) -> Bool)?
  ) {
    linkTextView.text = fullText
    linkTextView.addLinks(links)
    
    linkTextView.defaultTextColor = fullTextColor ?? .fancy.darkAndLightTheme.primaryGray
    linkTextView.defaultTextFont = fullTextFont
    linkTextView.linkColor = linkColor ?? .fancy.only.primaryBlue
    linkTextView.defaultTextAlignment = fullTextAlignment ?? .center
    linkTextView.actionLinkTap = actionLinkTap
  }

  public override func prepareForReuse() {
    super.prepareForReuse()

    linkTextView.text = nil
    linkTextView.addLinks([:])

    linkTextView.defaultTextColor = .fancy.darkAndLightTheme.primaryGray
    linkTextView.defaultTextFont = fancyFont.primaryMedium14
    linkTextView.linkColor = .fancy.only.primaryBlue
    linkTextView.defaultTextAlignment = .center
    linkTextView.actionLinkTap = nil
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [linkTextView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      linkTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: appearance.defaultInsets),
      linkTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -appearance.defaultInsets),
      linkTextView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: appearance.minInset),
      linkTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
  }
}

// MARK: - Appearance

private extension LinkTextViewCell {
  struct Appearance {
    let minInset: CGFloat = 8
    let defaultInsets: CGFloat = 16
  }
}
