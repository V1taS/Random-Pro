//
//  LinkCopyView.swift
//
//  Created by Vitalii Sosin on 30.07.2023.
//

import UIKit
import FancyStyle

/// View для экрана
public final class LinkCopyView: UIView {
  
  // MARK: - Private properties
  
  private let copyButton = ButtonView(type: .system)
  private let linkLabel = UILabel()
  private var action: ((_ link: String?) -> Void)?
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
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - link: Ссылка
  ///  - action: Действие при нажатии на кнопку
  public func configureWith(link: String?, action: ((_ link: String?) -> Void)?) {
    linkLabel.text = link
    self.action = action
  }
}

// MARK: - Private

private extension LinkCopyView {
  func configureLayout() {
    let appearance = Appearance()
    
    [copyButton, linkLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      copyButton.heightAnchor.constraint(equalToConstant: appearance.copyButtonSize.height),
      copyButton.widthAnchor.constraint(equalToConstant: appearance.copyButtonSize.width),
      
      copyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      copyButton.topAnchor.constraint(equalTo: topAnchor),
      copyButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      linkLabel.leadingAnchor.constraint(equalTo: copyButton.trailingAnchor, constant: appearance.inset),
      linkLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      linkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.inset)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    layer.cornerRadius = appearance.cornerRadius
    layer.borderWidth = 1
    layer.borderColor = .fancy.darkAndLightTheme.primaryGray.cgColor
    clipsToBounds = true
    
    linkLabel.textColor = .fancy.only.primaryBlue
    linkLabel.font = fancyFont.primaryRegular16
    
    let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
    let copyButtonImage = UIImage(systemName: appearance.copyButtonName)?.withConfiguration(configuration)
    
    copyButton.layer.cornerRadius = .zero
    copyButton.setImage(copyButtonImage, for: .normal)
    copyButton.gradientBackground = [
      .fancy.only.primaryGreen,
      .fancy.only.secondaryGreen
    ]
    copyButton.tintColor = .fancy.only.primaryWhite
    copyButton.addTarget(self, action: #selector(copyButtonAction), for: .touchUpInside)
  }
  
  @objc
  func copyButtonAction() {
    guard let action else {
      return
    }
    action(linkLabel.text)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension LinkCopyView {
  struct Appearance {
    let copyButtonSize: CGSize = CGSize(width: 60, height: 40)
    let cornerRadius: CGFloat = 10
    let inset: CGFloat = 16
    let copyButtonName = "doc.on.doc"
  }
}
