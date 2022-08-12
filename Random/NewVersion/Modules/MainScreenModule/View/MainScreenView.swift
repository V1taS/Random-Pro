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
  
  /// Открыть раздел `Films`
  func openFilms()
  
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
  
  /// Открыть раздел `Password`
  func openRussianLotto()
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput: AnyObject {
  
  /// Настройка главного экрана
  ///  - Parameter models: Список моделек для ячейки
  func configureCellsWith(models: [MainScreenCellModel])
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [MainScreenCellModel] = []
  
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
  
  func configureCellsWith(models: [MainScreenCellModel]) {
    self.models = models
    collectionView.reloadData()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor, constant: appearance.collectionViewInsets.top),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: appearance.collectionViewInsets.left),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -appearance.collectionViewInsets.right),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.collectionViewInsets.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    
    backgroundColor = appearance.backgroundColor
    collectionView.backgroundColor = appearance.backgroundColor
    
    collectionView.alwaysBounceVertical = true
    collectionView.register(MainScreenCollectionViewCell.self,
                            forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInset
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = .zero
    collectionViewLayout.minimumLineSpacing = .zero
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDelegate

extension MainScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = models[indexPath.row].cell
    switch item {
    case .number:
      output?.openNumber()
    case .films:
      output?.openFilms()
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
    case .russianLotto:
      output?.openRussianLotto()
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
    let model = models[indexPath.row]
    cell.configureCellWith(model: model)
    return cell
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let backgroundColor = RandomColor.primaryWhite
    let estimatedRowHeight: CGFloat = 95
    let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.45
  }
}
