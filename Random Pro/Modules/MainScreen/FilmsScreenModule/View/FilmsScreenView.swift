//
//  FilmsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol FilmsScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol FilmsScreenViewInput {}

/// Псевдоним протокола UIView & FilmsScreenViewInput
typealias FilmsScreenViewProtocol = UIView & FilmsScreenViewInput

/// View для экрана
final class FilmsScreenView: FilmsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let filmsView = FilmView()
  
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
}

// MARK: - Private

private extension FilmsScreenView {
  func configureLayout() {
    [filmsView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      filmsView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filmsView.topAnchor.constraint(equalTo: topAnchor),
      filmsView.trailingAnchor.constraint(equalTo: trailingAnchor),
      filmsView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    filmsView.configureWith(backgroundImage: UIImage(named: "mock_films"),
                            title: "Кошачий",
                            description: "Кошк аоиошк аоиошк аоиошк аоиошк аоиошк аоиошк аоиошк аоиошв",
                            buttonTitle: "Сгенерировать",
                            buttonAction: {
      print("Кнопка нажата")
    })
  }
}

// MARK: - Appearance

private extension FilmsScreenView {
  struct Appearance {}
}
