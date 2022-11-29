//
//  MainScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol MainScreenViewOutput: AnyObject {
  
  /// Открыть раздел `Number`
  func openNumber()
  
  /// Открыть раздел `Teams`
  func openTeams()
  
  /// Открыть раздел `YesOrNo`
  func openYesOrNo()
  
  /// Открыть раздел `Character`
  func openCharacter()
  
  /// Открыть раздел `List`
  func openList()
  
  /// Открыть раздел `Coin`
  func openCoin()
  
  /// Открыть раздел `Cube`
  func openCube()
  
  /// Открыть раздел `DateAndTime`
  func openDateAndTime()
  
  /// Открыть раздел `Lottery`
  func openLottery()
  
  /// Открыть раздел `Contact`
  func openContact()
  
  /// Открыть раздел `Password`
  func openPassword()
  
  /// Открыть раздел `Colors`
  func openColors()
  
  /// Открыть раздел `Bottle`
  func openBottle()
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput: AnyObject {
  
  /// Настройка главного экрана
  ///  - Parameter models: Список моделек для ячейки
  func configureCellsWith(models: [MainScreenModel.Section])
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [MainScreenModel.Section] = []
  
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
  
  func configureCellsWith(models: [MainScreenModel.Section]) {
    self.models = models
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDelegate

extension MainScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let section = models[indexPath.row].type
    switch section {
    case .number:
      output?.openNumber()
    case .teams:
      output?.openTeams()
    case .yesOrNo:
      output?.openYesOrNo()
    case .letter:
      output?.openCharacter()
    case .list:
      output?.openList()
    case .coin:
      output?.openCoin()
    case .cube:
      output?.openCube()
    case .dateAndTime:
      output?.openDateAndTime()
    case .lottery:
      output?.openLottery()
    case .contact:
      output?.openContact()
    case .password:
      output?.openPassword()
    case .colors:
      output?.openColors()
    case .bottle:
      output?.openBottle()
    }
  }
}

// MARK: - UICollectionViewDataSource

extension MainScreenView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? MainScreenCollectionViewCell else {
      return UICollectionViewCell()
    }
    let section = models[indexPath.row]
    cell.configureCellWith(model: section)
    return cell
  }
}

// MARK: - Private

private extension MainScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor,
                                          constant: appearance.collectionViewInsets.top),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor,
                                           constant: appearance.collectionViewInsets.left),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor,
                                            constant: -appearance.collectionViewInsets.right),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -appearance.collectionViewInsets.bottom),
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    collectionView.backgroundColor = RandomColor.primaryWhite
    collectionView.alwaysBounceVertical = true
    collectionView.register(MainScreenCollectionViewCell.self,
                            forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInsets
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = .zero
    collectionViewLayout.minimumLineSpacing = .zero
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let estimatedRowHeight: CGFloat = 95
    let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.45
  }
}
