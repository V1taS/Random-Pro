//
//  ShareScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ShareScreenViewOutput: AnyObject {
  
}

/// События которые отправляем от Presenter ко View
protocol ShareScreenViewInput: AnyObject {
  
  /// Обновить контент
  ///  - Parameter imageData: Изображение контента
  func updateContentWith(imageData: Data?)
}

/// Псевдоним протокола UIView & ShareScreenViewInput
typealias ShareScreenViewProtocol = UIView & ShareScreenViewInput

/// View для экрана
final class ShareScreenView: ShareScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ShareScreenViewOutput?
  
  // MARK: - Private properties
  
  private let scrollView = UIScrollView()
  private let contentView = UIImageView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(imageData: Data?) {
    guard let imageData = imageData else {
      return
    }

    contentView.image = UIImage(data: imageData)
  }
}

// MARK: - Private

private extension ShareScreenView {
  func configureLayout() {
    [scrollView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [contentView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
  }
}

// MARK: - Appearance

private extension ShareScreenView {
  struct Appearance {}
}
