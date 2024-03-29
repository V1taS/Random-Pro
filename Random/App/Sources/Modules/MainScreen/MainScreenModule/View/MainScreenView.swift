//
//  MainScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

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
  
  /// Открыть раздел `Rock Paper Scissors`
  func openRockPaperScissors()
  
  /// Открыть раздел `Image Filters`
  func openImageFilters()
  
  /// Открыть раздел `Films`
  func openFilms()
  
  /// Открыть раздел `NickName`
  func openNickName()
  
  /// Открыть раздел `Names`
  func openNames()
  
  /// Открыть раздел `Joke`
  func openJoke()
  
  /// Открыть раздел `Поздравления`
  func openCongratulations()
  
  /// Открыть раздел `Добрые дела`
  func openGoodDeeds()
  
  /// Открыть раздел `Загадки`
  func openRiddles()
  
  /// Открыть раздел `Подарки`
  func openGifts()
  
  /// Открыть раздел `Слоганы`
  func openSlogans()
  
  /// Открыть раздел `Цитаты`
  func openQuotes()
  
  /// Открыть раздел `Правда или дело`
  func openTruthOrDare()
  
  /// Открыть раздел `Колесо фортуны`
  func openFortuneWheel()
  
  /// Открыть раздел `Мемы`
  func openMemes()

  /// Открыть раздел `Сериалы`
  func openSeries()
  
  /// Нет премиум доступа
  /// - Parameter section: Секция на главном экране
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section)
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput {
  
  /// Настройка главного экрана
  ///  - Parameter model: Можелька
  func configureCellsWith(model: MainScreenModel)
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Section
  
  enum Section {
    case main
  }
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, MainScreenModel.Section>?
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var model: MainScreenModel?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
    configureDataSource()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func configureCellsWith(model: MainScreenModel) {
    self.model = model
    var snapshot = NSDiffableDataSourceSnapshot<Section, MainScreenModel.Section>()
    snapshot.appendSections([.main])
    snapshot.appendItems(model.allSections, toSection: .main)
    dataSource?.apply(snapshot, animatingDifferences: true)
    collectionView.reloadData()
  }
  
  func configureDataSource() {
    let dataSource = UICollectionViewDiffableDataSource<Section, MainScreenModel.Section>(
      collectionView: collectionView) { collectionView, indexPath, _ in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier,
          for: indexPath) as? MainScreenCollectionViewCell,
              let model = self.model else {
          return UICollectionViewCell()
        }
        
        let section = model.allSections[indexPath.row]
        cell.configureCellWith(section: section, isPremium: model.isPremium)
        return cell
      }
    
    self.dataSource = dataSource
    var snapshot = NSDiffableDataSourceSnapshot<Section, MainScreenModel.Section>()
    snapshot.appendSections([.main])
    self.dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - UICollectionViewDelegate

extension MainScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let model else {
      return
    }
    let section = model.allSections[indexPath.row]
    
    let isDisabled: Bool
    switch model.isPremium {
    case true:
      isDisabled = false
    case false:
      isDisabled = section.isPremium
    }
    
    if isDisabled {
      output?.noPremiumAccessActionFor(section)
    } else {
      switch section.type {
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
      case .rockPaperScissors:
        output?.openRockPaperScissors()
      case .imageFilters:
        output?.openImageFilters()
      case .films:
        output?.openFilms()
      case .nickName:
        output?.openNickName()
      case .names:
        output?.openNames()
      case .congratulations:
        output?.openCongratulations()
      case .goodDeeds:
        output?.openGoodDeeds()
      case .riddles:
        output?.openRiddles()
      case .joke:
        output?.openJoke()
      case .gifts:
        output?.openGifts()
      case .slogans:
        output?.openSlogans()
      case .quotes:
        output?.openQuotes()
      case .fortuneWheel:
        output?.openFortuneWheel()
      case .truthOrDare:
        output?.openTruthOrDare()
      case .memes:
        output?.openMemes()
      case .series:
        output?.openSeries()
      }
    }
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
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    collectionView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
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
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let estimatedRowHeight: CGFloat = 90
    let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.45
  }
}
