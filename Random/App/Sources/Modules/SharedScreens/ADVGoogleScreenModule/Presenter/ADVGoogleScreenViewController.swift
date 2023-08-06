//
//  ADVGoogleScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//

import UIKit
import GoogleMobileAds
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ADVGoogleScreenModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ADVGoogleScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ADVGoogleScreenModuleOutput? { get set }
}

/// Готовый модуль `ADVGoogleScreenModule`
typealias ADVGoogleScreenModule = ViewController & ADVGoogleScreenModuleInput

/// Презентер
final class ADVGoogleScreenViewController: ADVGoogleScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ADVGoogleScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ADVGoogleScreenInteractorInput
  private let moduleView: ADVGoogleScreenViewProtocol
  private let factory: ADVGoogleScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private lazy var adLoader: GADAdLoader = {
    let mediaOptions = GADNativeAdMediaAdLoaderOptions()
    mediaOptions.mediaAspectRatio = .portrait
    
    let viewOptions = GADNativeAdViewAdOptions()
    viewOptions.preferredAdChoicesPosition = .topRightCorner
    
    let imageOptions = GADNativeAdImageAdLoaderOptions()
    imageOptions.disableImageLoading = false
    
    let loader = GADAdLoader(adUnitID: Appearance().adUnitID,
                             rootViewController: self,
                             adTypes: [.native],
                             options: [mediaOptions, viewOptions, imageOptions])
    loader.delegate = self
    return loader
  }()
  
  private lazy var closeButton = UIBarButtonItem(image: Appearance().closeButtonIcon,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(closeButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ADVGoogleScreenViewProtocol,
       interactor: ADVGoogleScreenInteractorInput,
       factory: ADVGoogleScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    moduleView.startLoader()
    interactor.estimatedSecondsAction()
    adLoader.load(GADRequest())
    closeButton.isEnabled = false
  }
}

// MARK: - ADVGoogleScreenViewOutput

extension ADVGoogleScreenViewController: ADVGoogleScreenViewOutput {}

// MARK: - ADVGoogleScreenInteractorOutput

extension ADVGoogleScreenViewController: ADVGoogleScreenInteractorOutput {
  func didReceiveEstimatedSeconds(_ seconds: Int) {
    moduleView.setEstimatedSeconds(seconds)
    
    guard seconds == .zero else {
      return
    }
    closeButton.isEnabled = true
  }
}

// MARK: - ADVGoogleScreenFactoryOutput

extension ADVGoogleScreenViewController: ADVGoogleScreenFactoryOutput {}

// MARK: - Private

private extension ADVGoogleScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [closeButton]
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
    moduleOutput?.moduleClosed()
    impactFeedback.impactOccurred()
  }
}

// MARK: - GADNativeAdLoaderDelegate

extension ADVGoogleScreenViewController: GADNativeAdLoaderDelegate {
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    moduleView.stopLoader()
    moduleView.setNativeAd(nativeAd)
  }
}

// MARK: - GADAdLoaderDelegate

extension ADVGoogleScreenViewController: GADAdLoaderDelegate {
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    moduleView.stopLoader()
    moduleOutput?.closeButtonAction()
    closeButton.isEnabled = true
  }
}

// MARK: - Appearance

private extension ADVGoogleScreenViewController {
  struct Appearance {
    let adUnitID = "ca-app-pub-7937689622380151/6383798458"
    let title = RandomStrings.Localizable.advertising
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
