//
//  PremiumScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol PremiumScreenViewOutput: AnyObject {
  
  /// Выбрана карточка с месячной подпиской
  /// - Parameters:
  ///  - purchaseType: Тип платной услуги
  ///  - amount: Стоимость услуги
  func monthlySubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType,
                                       amount: String?)
  
  /// Выбрана карточка с годовой подпиской
  /// - Parameters:
  ///  - purchaseType: Тип платной услуги
  ///  - amount: Стоимость услуги
  func annualSubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType,
                                      amount: String?)
  
  /// Выбрана карточка с пожизненным доступом
  /// - Parameters:
  ///  - purchaseType: Тип платной услуги
  ///  - amount: Стоимость услуги
  func lifetimeAccessCardSelected(_ purchaseType: PremiumScreenPurchaseType,
                                  amount: String?)
  
  /// Страница онбординга была изменена
  func didChangePageAction()
  
  /// Основная кнопка была нажата
  /// - Parameter purchaseType: Тип платной услуги
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType)
  
  /// Кнопка восстановить была нажата
  func restorePurchaseButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol PremiumScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [PremiumScreenSectionType])
  
  /// Обновить название кнопки
  /// - Parameter title: Заголовок кнопки
  func updateButtonWith(title: String?)
  
  /// Запустить лоадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & PremiumScreenViewInput
typealias PremiumScreenViewProtocol = UIView & PremiumScreenViewInput

/// View для экрана
final class PremiumScreenView: PremiumScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [PremiumScreenSectionType] = []
  private var cachePurchaseType: PremiumScreenPurchaseType = .monthly
  
  private let bottomContainerView = UIView()
  private let dividerView = UIView()
  private let restorePurchaseButton = SmallButtonView()
  private let mainButton = ButtonView()
  private let linkTextView = LinkTextView()
  
  private let loaderView = LottieAnimationView(name: Appearance().cardPaymentLoader, bundle: .main)
  private let loaderLabel = UILabel()
  
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
  
  func updateContentWith(models: [PremiumScreenSectionType]) {
    self.models = models
    tableView.reloadData()
  }
  
  func updateButtonWith(title: String?) {
    mainButton.setTitle(title, for: .normal)
  }
  
  func startLoader() {
    addBackgroundBlurWith(.regular, alpha: Appearance().alpha)
    loaderView.isHidden = false
    loaderLabel.isHidden = false
    loaderView.contentMode = .scaleAspectFit
    loaderView.loopMode = .loop
    loaderView.animationSpeed = Appearance().animationSpeed
    loaderView.play()
    mainButton.set(isEnabled: false)
    bringSubviewToFront(loaderView)
    bringSubviewToFront(loaderLabel)
  }
  
  func stopLoader() {
    removeBackgroundBlur()
    loaderView.stop()
    loaderView.isHidden = true
    loaderLabel.isHidden = true
    mainButton.set(isEnabled: true)
  }
}

// MARK: - Private

private extension PremiumScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [restorePurchaseButton, mainButton, linkTextView, dividerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      bottomContainerView.addSubview($0)
    }
    
    [tableView, bottomContainerView, loaderView, loaderLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      loaderView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: appearance.maxInset),
      loaderView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: -appearance.loaderInset),
      loaderView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -appearance.maxInset),
      
      loaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.maxInset),
      loaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                           constant: appearance.maxInset),
      loaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.maxInset),
      
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
      
      bottomContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      dividerView.heightAnchor.constraint(equalToConstant: appearance.dividerHeight),
      dividerView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
      dividerView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
      dividerView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
      
      restorePurchaseButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor,
                                                     constant: appearance.defaultInset),
      restorePurchaseButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor,
                                                 constant: appearance.minInset),
      restorePurchaseButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor,
                                                      constant: -appearance.defaultInset),
      
      mainButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor,
                                          constant: appearance.defaultInset),
      mainButton.topAnchor.constraint(equalTo: restorePurchaseButton.bottomAnchor,
                                      constant: appearance.minInset),
      mainButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor,
                                           constant: -appearance.defaultInset),
      
      linkTextView.topAnchor.constraint(equalTo: mainButton.bottomAnchor,
                                        constant: appearance.minInset),
      linkTextView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
      linkTextView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor,
                                           constant: -appearance.maxInset)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    dividerView.backgroundColor = fancyColor.only.secondaryGray
    
    restorePurchaseButton.setTitle(appearance.restoreTitle, for: .normal)
    restorePurchaseButton.setTitleColor(fancyColor.only.primaryBlue, for: .normal)
    
    linkTextView.backgroundColor = .clear
    let termsConditionsAndPrivacyPolicy = "\(appearance.termsConditions) \(appearance.andTitle) \(appearance.privacyPolicy)"
    linkTextView.text = termsConditionsAndPrivacyPolicy
    linkTextView.addLinks([
      appearance.termsConditions: appearance.termsAndConditionsLink,
      appearance.privacyPolicy: appearance.privacyPolicyLink
    ])
    
    bottomContainerView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    mainButton.setTitle(appearance.subscribeTitle, for: .normal)
    mainButton.addTarget(self, action: #selector(mainButtonAction), for: .touchUpInside)
    restorePurchaseButton.addTarget(self, action: #selector(restorePurchaseButtonAction), for: .touchUpInside)
    
    loaderLabel.textAlignment = .center
    loaderLabel.font = fancyFont.primaryMedium32
    loaderLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    loaderLabel.text = "\(appearance.processingPaymentTitle)..."
    loaderLabel.numberOfLines = appearance.numberOfLines
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    
    tableView.register(OnboardingViewCell.self,
                       forCellReuseIdentifier: OnboardingViewCell.reuseIdentifier)
    tableView.register(PurchasesCardsCell.self,
                       forCellReuseIdentifier: PurchasesCardsCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    
    tableView.separatorStyle = .none
    tableView.contentInset.bottom = appearance.defaultInset
    
    stopLoader()
  }

  func updateButtonTitleWith(monthlyAmount: String?,
                             yearlyAmount: String?,
                             lifetimeAmount: String?) {
    let appearance = Appearance()
    let buttontitle = cachePurchaseType == .lifetime ? appearance.purchaseTitle : appearance.subscribeTitle
    var amount: String?
    switch cachePurchaseType {
    case .monthly:
      amount = monthlyAmount
    case .yearly:
      amount = yearlyAmount
    case .lifetime:
      amount = lifetimeAmount
    }
    mainButton.setTitle("\(buttontitle) \(appearance.forTitle) \(amount ?? "")", for: .normal)
  }
  
  @objc
  func mainButtonAction() {
    output?.mainButtonAction(cachePurchaseType)
  }
  
  @objc
  func restorePurchaseButtonAction() {
    output?.restorePurchaseButtonAction()
  }
}

// MARK: - UITableViewDelegate

extension PremiumScreenView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension PremiumScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let appearance = Appearance()
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .onboardingPage(models):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: OnboardingViewCell.reuseIdentifier
      ) as? OnboardingViewCell {
        cell.configureCellWith(
          OnboardingViewModel(
            pageModels: models,
            didChangePageAction: { [weak self] _ in
              self?.output?.didChangePageAction()
            })
        )
        viewCell = cell
      }
    case let .purchasesCards(leftSideCardAmount, centerSideCardAmount, rightSideCardAmount):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: PurchasesCardsCell.reuseIdentifier
      ) as? PurchasesCardsCell {
        updateButtonTitleWith(monthlyAmount: centerSideCardAmount,
                              yearlyAmount: leftSideCardAmount,
                              lifetimeAmount: rightSideCardAmount)

        cell.configureCellWith(
          models: [
            PurchasesCardsCellModel(header: appearance.sevenDaysFreeTitle,
                                    title: appearance.yearlyCountTitle,
                                    description: appearance.yearlyTitle,
                                    amount: leftSideCardAmount,
                                    action: { [weak self] in
                                      self?.cachePurchaseType = .yearly
                                      self?.output?.annualSubscriptionCardSelected(.yearly,
                                                                                   amount: leftSideCardAmount)
                                    }),
            PurchasesCardsCellModel(header: appearance.mostPopularTitle,
                                    title: appearance.monthlyCountTitle,
                                    description: appearance.monthlyTitle,
                                    amount: centerSideCardAmount,
                                    action: { [weak self] in
                                      self?.cachePurchaseType = .monthly
                                      self?.output?.monthlySubscriptionCardSelected(.monthly,
                                                                                    amount: centerSideCardAmount)
                                    }),
            PurchasesCardsCellModel(header: appearance.oneTimePurchaseTitle,
                                    title: appearance.oneTimePCountTitle,
                                    description: appearance.lifetimeTitle,
                                    amount: rightSideCardAmount,
                                    action: { [weak self] in
                                      self?.cachePurchaseType = .lifetime
                                      self?.output?.lifetimeAccessCardSelected(.lifetime,
                                                                               amount: rightSideCardAmount)
                                    })
          ]
        )
        viewCell = cell
      }
    case let .padding(height):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: height)
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - Appearance

private extension PremiumScreenView {
  struct Appearance {
    let minInset: CGFloat = 8
    let maxInset: CGFloat = 32
    let loaderInset: CGFloat = 100
    let defaultInset: CGFloat = 16
    let animationSpeed: CGFloat = 0.5
    let alpha: CGFloat = 0.7
    let dividerHeight: CGFloat = 0.2
    let numberOfLines = 2
    
    let termsConditions = RandomStrings.Localizable.terms
    let andTitle = RandomStrings.Localizable.and
    let privacyPolicy = RandomStrings.Localizable.privacyPolicy
    let restoreTitle = RandomStrings.Localizable.restore
    
    let termsAndConditionsLink = "https://sosinvitalii.com/terms-conditions"
    let privacyPolicyLink = "https://sosinvitalii.com/privacy-policy"
    
    let monthlyTitle = RandomStrings.Localizable.monthly
    let mostPopularTitle = RandomStrings.Localizable.mostPopular
    let monthlyCountTitle = "1"

    let yearlyTitle = RandomStrings.Localizable.annually
    let sevenDaysFreeTitle = RandomStrings.Localizable.sevenDaysFree
    let yearlyCountTitle = "12"
    
    let lifetimeTitle = RandomStrings.Localizable.forever
    let oneTimePurchaseTitle = RandomStrings.Localizable.oneTimePurchase
    let oneTimePCountTitle = "∞"
    
    let cardPaymentLoader = RandomAsset.cardPaymentInProcess.name
    let processingPaymentTitle = RandomStrings.Localizable.processingPayment
    
    let purchaseTitle = RandomStrings.Localizable.buy
    let forTitle = RandomStrings.Localizable.for
    let subscribeTitle = RandomStrings.Localizable.subscribe
  }
}
