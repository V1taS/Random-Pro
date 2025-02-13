//
//  MainScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyUIKit
import FancyStyle
import SKAbstractions

/// События, которые отправляем из View в Presenter
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
  
  /// Открыть раздел `Films`
  func openFilms()
  
  /// Открыть раздел `Names`
  func openNames()
  
  /// Открыть раздел `Joke`
  func openJoke()
  
  /// Открыть раздел `Поздравления`
  func openCongratulations()
  
  /// Открыть раздел `Подарки`
  func openGifts()
  
  /// Открыть раздел `Колесо фортуны`
  func openFortuneWheel()
  
  /// Открыть раздел `Мемы`
  func openMemes()
  
  /// Открыть рекламу
  func openADV(urlString: String?)
  
  /// Нет премиум доступа
  /// - Parameter section: Секция на главном экране
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section)
}

/// События, которые отправляем от Presenter ко View
protocol MainScreenViewInput {
  
  /// Настройка главного экрана
  /// - Parameter model: Модель
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
  
  // MARK: - Внутренние свойства
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Приватные свойства
  
  private let collectionViewLayout: UICollectionViewFlowLayout
  private let collectionView: UICollectionView
  private var model: MainScreenModel?
  
  // MARK: - Инициализация
  
  override init(frame: CGRect) {
    let collectionViewLayout = UICollectionViewFlowLayout()
    self.collectionViewLayout = collectionViewLayout
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    super.init(frame: frame)
    configureLayout()
    applyDefaultBehavior()
    configureDataSource()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Внутренние методы
  
  func configureCellsWith(model: MainScreenModel) {
    var modelUpdated = model
    
    if SecretsAPI.isPremium {
      modelUpdated.allSections = modelUpdated.allSections.filter({ !$0.type.isADV })
    }
    self.model = modelUpdated
    collectionView.reloadData()
  }
  
  func configureDataSource() {
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource

extension MainScreenView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model?.allSections.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
      case .films:
        output?.openFilms()
      case .names:
        output?.openNames()
      case .congratulations:
        output?.openCongratulations()
      case .joke:
        output?.openJoke()
      case .gifts:
        output?.openGifts()
      case .fortuneWheel:
        output?.openFortuneWheel()
      case .memes:
        output?.openMemes()
      case .adv1:
        output?.openADV(urlString: section.advStringURL)
      case .adv2:
        output?.openADV(urlString: section.advStringURL)
      case .adv3:
        output?.openADV(urlString: section.advStringURL)
      case .adv4:
        output?.openADV(urlString: section.advStringURL)
      }
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainScreenView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let appearance = Appearance()
    return CGSize(width: appearance.cellWidthConstant,
                  height: appearance.estimatedRowHeight)
  }
}

// MARK: - Приватные методы

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
                                             constant: -appearance.collectionViewInsets.bottom)
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

// MARK: - Внешний вид

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let estimatedRowHeight: CGFloat = 100
    let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.45
  }
}
