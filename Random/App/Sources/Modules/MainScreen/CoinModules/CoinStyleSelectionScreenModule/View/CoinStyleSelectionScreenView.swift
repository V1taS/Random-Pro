//
//  CoinStyleSelectionScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol CoinStyleSelectionScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol CoinStyleSelectionScreenViewInput {

  /// Обновить контент
  /// - Parameter models: Список моделек стилей монеток
  func updateContentWith(models: [CoinStyleSelectionScreenModel])
}

/// Псевдоним протокола UIView & CoinStyleSelectionScreenViewInput
typealias CoinStyleSelectionScreenViewProtocol = UIView & CoinStyleSelectionScreenViewInput

/// View для экрана
final class CoinStyleSelectionScreenView: CoinStyleSelectionScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: CoinStyleSelectionScreenViewOutput?
  
  // MARK: - Private properties

  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  private var models: [CoinStyleSelectionScreenModel] = []

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
  func updateContentWith(models: [CoinStyleSelectionScreenModel]) {
    self.models = models
    collectionView.reloadData()
  }
}

// MARK: - Private

private extension CoinStyleSelectionScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenView {
  struct Appearance {}
}
